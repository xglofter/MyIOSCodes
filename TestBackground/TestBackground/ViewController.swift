//
//  ViewController.swift
//  TestBackground
//
//  Created by guang xu on 16/7/5.
//  Copyright © 2016年 Richard. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ViewController: UIViewController {

    var textField: UITextField!
    var player: AVAudioPlayer!
    var isUserLightBar: Bool = true
    var downloadProgress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        // for audioplayer
        let avSession = AVAudioSession.sharedInstance()
        try! avSession.setActive(true)
        try! avSession.setCategory(AVAudioSessionCategoryPlayback)
        
        let path = NSBundle.mainBundle().pathForResource("LuckyDay", ofType: "mp3")
        let url = NSURL(fileURLWithPath: path!)
        player = try? AVAudioPlayer(contentsOfURL: url)
        player?.prepareToPlay()
        player?.numberOfLoops = 1 // -1 means forever
        player?.volume = 1
        
        let playButton = UIButton()
        playButton.frame = CGRectMake(20, 100, 200, 50)
        playButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playButton.setTitle("Play", forState: .Normal)
        playButton.backgroundColor = UIColor.whiteColor()
        playButton.addTarget(self, action: #selector(onPlayMusic), forControlEvents: .TouchUpInside)
        self.view.addSubview(playButton)
        
        // for statusbar changes
        let switchButton = UISwitch()
        switchButton.on = true
        switchButton.frame.origin = CGPointMake(20, 200)
        switchButton.addTarget(self, action: #selector(onBarChanges), forControlEvents: .ValueChanged)
        self.view.addSubview(switchButton)
        
        // for download
        let downloadButton = UIButton()
        downloadButton.frame = CGRectMake(20, 300, 200, 50)
        downloadButton.backgroundColor = UIColor.whiteColor()
        downloadButton.addTarget(self, action: #selector(onDownloadAction), forControlEvents: .TouchUpInside)
        downloadButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        downloadButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        downloadButton.setTitle("download", forState: .Normal)
        self.view.addSubview(downloadButton)
        
        downloadProgress = UIProgressView()
        downloadProgress.frame = CGRectMake(20, 380, 200, 20)
        downloadProgress.progress = 0
        self.view.addSubview(downloadProgress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if isUserLightBar {
            return .LightContent
        } else {
            return .Default
        }
    }
    
    // MARK: - callback functions
    
    func onPlayMusic(sender: UIButton) {
        if !player.playing {
            player.play()
        }
    }
    
    func onBarChanges(sender: UISwitch) {
        isUserLightBar = sender.on
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func onDownloadAction(sender: UIButton) {
        print("onDownloadAction")
        sender.enabled = false

        // download to default path
        let destination = Alamofire.Request.suggestedDownloadDestination()
        let url = "http://7xi8t0.com2.z0.glb.clouddn.com/o_1ah8n9j7c1ltmo7g1hpn3asi9m.apk"
        Alamofire.download(.GET, url, destination: destination).progress { (bytes, totalBytes, totalBytesExpected) in
            print(bytes, totalBytes, totalBytesExpected)
            let percent: Float = Float(totalBytes) / Float(totalBytesExpected)
            print(">> ", percent)
            dispatch_async(dispatch_get_main_queue(), {
                self.downloadProgress.progress = percent
            });
        }.response { (request, response, _, error) in
            if let error = error {
                print("Error:", error)
                self.sendLocalNotification("Download Error!")
            } else {
                print("Success:", response)
                self.sendLocalNotification("Download Success!")
            }
        }
        
    }
    
    func sendLocalNotification(msg: String) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let localNotification = UILocalNotification()
        localNotification.applicationIconBadgeNumber = 1
        localNotification.fireDate = NSDate(timeInterval: 5, sinceDate: NSDate(timeIntervalSinceNow: 0))
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.alertBody = msg
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
