## XGDownloader

文件下载器

使用方法：

```swift

class ViewController: UIViewController {
    
  let url1 = "http://cdn.download.cp41.ott.cibntv.net/o_19sj4dbnj18n2gd7ko01f0fhdl7.jpg"
  let url2 = "http://down2.20012.com/marketexe/pccwc.exe"
  
  var button1: UIButton!
  var button2: UIButton!
  var buttonDelete1: UIButton!
  var buttonDelete2: UIButton!
  var progressLabel1: UILabel!
  var progressLabel2: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    button1 = UIButton()
    button1.setTitle("url1", for: .normal)
    button1.frame = CGRect(x: 20, y: 100, width: 150, height: 30)
    button1.backgroundColor = UIColor.brown
    button1.addTarget(self, action: #selector(onButton1Action), for: .touchUpInside)
    self.view.addSubview(button1)
    
    button2 = UIButton()
    button2.setTitle("url2", for: .normal)
    button2.frame = CGRect(x: 20, y: 200, width: 150, height: 30)
    button2.backgroundColor = UIColor.brown
    button2.addTarget(self, action: #selector(onButton2Action), for: .touchUpInside)
    self.view.addSubview(button2)
    
    buttonDelete1 = UIButton()
    buttonDelete1.setTitle("删除", for: .normal)
    buttonDelete1.frame = CGRect(x: 200, y: 100, width: 60, height: 30)
    buttonDelete1.backgroundColor = UIColor.red
    buttonDelete1.addTarget(self, action: #selector(onDelete1Action), for: .touchUpInside)
    self.view.addSubview(buttonDelete1)
    
    buttonDelete2 = UIButton()
    buttonDelete2.setTitle("删除", for: .normal)
    buttonDelete2.frame = CGRect(x: 200, y: 200, width: 60, height: 30)
    buttonDelete2.backgroundColor = UIColor.red
    buttonDelete2.addTarget(self, action: #selector(onDelete2Action), for: .touchUpInside)
    self.view.addSubview(buttonDelete2)
    
    progressLabel1 = UILabel()
    progressLabel1.text = String(format: "%.2f%", XGDownloader.shared.progress(url1) * 100)
    progressLabel1.frame = CGRect(x: 280, y: 100, width: 80, height: 30)
    self.view.addSubview(progressLabel1)
    
    progressLabel2 = UILabel()
    progressLabel2.text = String(format: "%.2f%", XGDownloader.shared.progress(url2) * 100)
    progressLabel2.frame = CGRect(x: 280, y: 200, width: 80, height: 30)
    self.view.addSubview(progressLabel2)
    
  }
  
  @objc private func onButton1Action() {
    
    XGDownloader.shared.download(url: url1, progressCallback: { (recived, expected) in
      self.progressLabel1.text = String(format: "%.2f%%", Double(recived)/Double(expected) * 100)
    }, stateCallback: { (state) in
      self.button1.setTitle(state.rawValue, for: .normal)
      if state == .completed {
        print(XGDownloader.shared.getFullPath(self.url1))
      }
    })
  }
  
  @objc private func onButton2Action() {
    XGDownloader.shared.download(url: url2, progressCallback: { (recived, expected) in
      self.progressLabel2.text = String(format: "%.2f%%", Double(recived)/Double(expected) * 100)
    }, stateCallback: { (state) in
      self.button2.setTitle(state.rawValue, for: .normal)
      if state == .completed {
        print(XGDownloader.shared.getFullPath(self.url2))
      }
    })
  }
  
  @objc private func onDelete1Action() {
    XGDownloader.shared.deleteFile(url1)
  }
  
  @objc private func onDelete2Action() {
    XGDownloader.shared.deleteFile(url2)
  }
  
}

```
