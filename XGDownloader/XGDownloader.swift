//
//  XGDownloader.swift
//  TestSwift3
//
//  Created by guang xu on 2017/7/4.
//  Copyright © 2017年 Richard. All rights reserved.
//

import Foundation


// MARK: - XGDownloadState

public enum XGDownloadState: String {
  case start      = "START"
  case suspended  = "SUSPENDED"
  case completed  = "COMPLETED"
  case failed     = "FAILED"
  case canceled   = "CANCELED"
}


// MARK: - XGDownloadModel

public typealias ProgressCallback = (Int64, Int64) -> ()
public typealias StateCallback = (XGDownloadState) -> ()

public class XGDownloadModel: NSObject {
  public var url: String!           // url path
  public var stream: OutputStream!  // output stream
  public var totalSize: Int64!      // download file total size
  public var progressCallback: ProgressCallback!  // callback for progress
  public var stateCallback: StateCallback!        // callback for download state
}

private let instance = XGDownloader()

public class XGDownloader: NSObject {
  /// 支持断点续传、进度查询、状态查询、实时回调
  /// 下载的文件放入 Library/Caches/XGCache/ 使用 url 的 MD5 值来作为文件名
  /// 目录下 totalSize.plist 用来保存各个文件的大小
  
  
  /// 存放任务
  fileprivate var tasks = [String: URLSessionDataTask]()
  
  /// 存放下载数据
  fileprivate var downloadModes = [String: XGDownloadModel]()
  
  /// 缓存目录
  fileprivate let XGCacheDirectory = {
    return (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("XGCache")
  }()
  
  
  // MARK: - Public Methods
  
  
  /// 获取单例
  public class var shared: XGDownloader {
    return instance
  }
  
  /// 下载某文件
  ///
  /// - Parameters:
  ///   - url: 文件路径
  ///   - progressFunc: 进度回调
  ///   - stateFunc: 状态回调
  public func download(url: String, progressCallback: ProgressCallback?, stateCallback: StateCallback?) {
    if url.isEmpty { return }
    if isCompletion(url) { stateCallback?(.completed); return }
    if tasks[getFileName(url)] != nil { trigger(url); return }
    
    createCacheDirectory()
    
    let config = URLSessionConfiguration.default
    let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)

    let stream = OutputStream(toFileAtPath: getFullPath(url), append: true)
    
    var request = URLRequest(url: URL(string: url)!)
    request.setValue("bytes=\(getDownloadSize(url))", forHTTPHeaderField: "Range")
    
    let downloadTask = urlSession.dataTask(with: request)
    downloadTask.setValue(Int(arc4random_uniform(UInt32.max)), forKey: "taskIdentifier")
    tasks.updateValue(downloadTask, forKey: getFileName(url))
    
    let model = XGDownloadModel()
    model.url = url
    model.stream = stream
    model.progressCallback = progressCallback
    model.stateCallback = stateCallback
    downloadModes.updateValue(model, forKey: String(downloadTask.taskIdentifier))
    
    start(url)
  }
  
  /// 获取进度
  ///
  /// - Parameter url: 资源网址
  /// - Returns: 进度值（0~1）
  public func progress(_ url: String) -> Double {
    if getFileTotalSize(url) == -1 {
      return 0.0
    } else if getFileTotalSize(url) == 0 {
      return 0.0
    } else {
      return Double(getDownloadSize(url)) / Double(getFileTotalSize(url))
    }
  }
  
  /// 查询是否完成下载
  ///
  /// - Parameter url: 资源网址
  /// - Returns: 是否完成
  public func isCompletion(_ url: String) -> Bool {
    if getFileTotalSize(url) != 0 && getDownloadSize(url) == getFileTotalSize(url) {
      return true
    } else {
      return false
    }
  }
  
  /// 删除资源以及下载的任务
  ///
  /// - Parameter url: 资源网址
  public func deleteFile(_ url: String) {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: getFullPath(url)) {
      try! fileManager.removeItem(atPath: getFullPath(url))
      
      tasks.removeValue(forKey: getFileName(url))
      
      if let task = getTask(url) {
        downloadModes.removeValue(forKey: String(task.taskIdentifier))
      }
      
      if fileManager.fileExists(atPath: getTotalSizeFilePath()) {
        let dict = NSMutableDictionary(contentsOfFile: getTotalSizeFilePath())
        dict?.removeObject(forKey: getFileName(url))
        dict?.write(toFile: getTotalSizeFilePath(), atomically: true)
      }
    }
  }
  
  
  /// 清除全部缓存资源以及任务
  public func deleteAllFiles() {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: XGCacheDirectory) {
      try! fileManager.removeItem(atPath: XGCacheDirectory)
      
      for (_, task) in tasks {
        task.cancel()
      }
      tasks.removeAll()
      
      for (_, model) in downloadModes {
        model.stream.close()
      }
      downloadModes.removeAll()
      
      if fileManager.fileExists(atPath: getTotalSizeFilePath()) {
        try! fileManager.removeItem(atPath: getTotalSizeFilePath())
      }
    }
  }
  
  /// 获取资源大小 (前提是已进入下载列表，或已下载完成)
  ///
  /// - Parameter url: 资源网址
  /// - Returns: 资源大小 bit
  public func getFileTotalSize(_ url: String) -> Int64 {
    if let value = NSDictionary.init(contentsOfFile: getTotalSizeFilePath())?[getFileName(url)] {
      return value as! Int64
    }
    return 0
  }
  
  
  func trigger(_ url: String) {
    if let task = getTask(url) {
      if task.state == .running {
        pause(url)
      } else {
        start(url)
      }
    }
  }
  
  func start(_ url: String) {
    if let task = getTask(url) {
      task.resume()
      getDownloadModel(taskId: task.taskIdentifier)?.stateCallback(.start)
    }
  }
  
  func pause(_ url: String) {
    if let task = getTask(url) {
      task.suspend()
      getDownloadModel(taskId: task.taskIdentifier)?.stateCallback(.suspended)
    }
  }
}

// MARK: - Internal Methods

extension XGDownloader {

  func getFileName(_ url: String) -> String {
    return url.md5
  }
  
  func getFullPath(_ url: String) -> String {
    return (XGCacheDirectory as NSString).appendingPathComponent(getFileName(url))
  }
  
  func getDownloadSize(_ url: String) -> Int64 {
    if FileManager.default.fileExists(atPath: getFullPath(url)) == false {
      return 0
    }
    return try! FileManager.default.attributesOfItem(atPath: getFullPath(url))[FileAttributeKey.size]  as! Int64
  }

  func getTotalSizeFilePath() -> String {
    return (XGCacheDirectory as NSString).appendingPathComponent("totalSize.plist")
  }
}


// MARK: - URLSessionDataDelegate

extension XGDownloader: URLSessionDataDelegate {
  
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    if let model = getDownloadModel(taskId: dataTask.taskIdentifier) {
      
      let statusCode = (response as! HTTPURLResponse).statusCode
      if statusCode != 200 && statusCode != 201 && statusCode != 304 {
        completionHandler(.cancel)
        return
      }

      model.stream.open()
      let totalSize = response.expectedContentLength + getDownloadSize(model.url)
      model.totalSize = totalSize
      
      var dict = NSMutableDictionary(contentsOfFile: getTotalSizeFilePath())
      if dict == nil { dict = NSMutableDictionary() }
      dict![getFileName(model.url)] = totalSize
      dict!.write(toFile: getTotalSizeFilePath(), atomically: true)
      
      completionHandler(.allow)
    }
  }
  
//  public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//      let cre = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//      completionHandler(URLSession.AuthChallengeDisposition.useCredential, cre)
//    } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
//      // ...
//    } else {
//      completionHandler(.cancelAuthenticationChallenge, nil)
//    }
//  }
  
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    guard let model = getDownloadModel(taskId: dataTask.taskIdentifier) else { return }
    _ = data.withUnsafeBytes { model.stream.write($0, maxLength: data.count) }

    let receivedSize = getDownloadSize(model.url)
    let expectedSize = model.totalSize
    model.progressCallback(receivedSize, expectedSize!)
  }
  
  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    guard let model = getDownloadModel(taskId: task.taskIdentifier) else { return }
    
    if error != nil { model.stateCallback(.failed) }
    else if isCompletion(model.url) { model.stateCallback(.completed) }
    
    model.stream.close()
    model.stream = nil
    
    tasks.removeValue(forKey: getFileName(model.url))
    downloadModes.removeValue(forKey: String(task.taskIdentifier))
  }
}

// MARK: - Private Methods

private extension XGDownloader {
  
  func createCacheDirectory() {
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: XGCacheDirectory) {
      try! fileManager.createDirectory(atPath: XGCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
  }
  
  func getTask(_ url: String) -> URLSessionDataTask? {
    return tasks[getFileName(url)]
  }
  
  func getDownloadModel(taskId: Int) -> XGDownloadModel? {
    return downloadModes[String(taskId)]
  }
}

