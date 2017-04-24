//
//  PreviewPhotosViewController.swift
//  Stitcher
//
//  Created by Richard on 2017/4/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit


class PhotoEditViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    private(set) var imageView: UIImageView!
    private(set) var containView: UIView!
    
    var image: UIImage!
    var maskView: PhotoMaskView!
    
    var superViewController: UIViewController?
    
    init(img: UIImage) {
        super.init(nibName: nil, bundle: nil)
        
        self.image = img
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // scrollview
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.black
        scrollView.frame = self.view.frame
        scrollView.delegate = self
        scrollView.bouncesZoom = false
        
        imageView = UIImageView(image: image)
        
        // container view
        let imageSize = (imageView.image?.size)!
        let scrollViewSize = scrollView.frame.size
        var scrollContentSize = CGSize(width: imageSize.width * 2, height: imageSize.height * 2)
        
        containView = UIView()
        containView.backgroundColor = UIColor.black
        containView.frame = CGRect(origin: CGPoint.zero, size: scrollContentSize)
        containView.addSubview(imageView)
        scrollView.addSubview(containView)
        self.view.addSubview(scrollView)
        
        imageView.center = CGPoint(x: imageSize.width, y: imageSize.height)
        
        // maskview
        maskView = PhotoMaskView()
        maskView.backgroundColor = UIColor.clear
        maskView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(maskView)
        
        // scrollview zooming
        
        let maskWidth = maskView.bounds.size.width
        let maskHeight = maskView.bounds.size.height
        let border = maskView.border
        
        let pickingFieldWidth = maskWidth < maskHeight ? (maskWidth - border) : (maskHeight - border)
        
        let scaleWidth = pickingFieldWidth / imageSize.width
        let scaleHeight = pickingFieldWidth / imageSize.height
        let minScale = max(scaleWidth, scaleHeight)
        
        if minScale > 1 {
            scrollView.maximumZoomScale = minScale * 2
            scrollContentSize.width = scrollContentSize.width * minScale
            scrollContentSize.height = scrollContentSize.height * minScale
        } else {
            scrollView.maximumZoomScale = 5
        }
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        
        scrollView.contentSize = scrollContentSize
        scrollView.contentOffset.x = imageSize.width * scrollView.zoomScale - scrollViewSize.width / 2
        scrollView.contentOffset.y = imageSize.height * scrollView.zoomScale - scrollViewSize.height / 2
        
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: UIControlState())
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelButton.addTarget(self, action: #selector(onCancelEdit), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(25)
            make.bottom.equalTo(self.view).offset(-50)
        }
        
        let finishButton = UIButton()
        finishButton.setTitle("确定", for: UIControlState())
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        finishButton.setTitleColor(UIColor.blue, for: UIControlState())
        finishButton.addTarget(self, action: #selector(onFinishEdit), for: .touchUpInside)
        self.view.addSubview(finishButton)
        
        finishButton.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.view).offset(-25)
            make.bottom.equalTo(self.view).offset(-50)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "调整头像"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.white
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(73)
            make.centerX.equalTo(self.view)
        }
    
    }
    
    func setPhoto(_ photo: UIImage) {
        imageView.image = photo
        let photoSize = photo.size
        imageView.frame = CGRect(origin: CGPoint.zero, size: photoSize)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        maskView.frame.size = size
        
        maskView.setNeedsDisplay()
    }
    
    // MARK: - auto rotate
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    // MARK: - Callback Functions
    
    func onCancelEdit(_ UIButton: UIBarButtonItem) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func onFinishEdit(_ UIButton: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
        superViewController?.dismiss(animated: true, completion: nil)
        
        let rect = maskView.pickingFieldRect
        var realRect = CGRect(x: 0,y: 0,width: 0,height: 0)
        realRect.origin.x = (rect?.origin.x)! + scrollView.contentOffset.x
        realRect.origin.y = (rect?.origin.y)! + scrollView.contentOffset.y
        realRect.origin.x = realRect.origin.x / scrollView.zoomScale - imageView.frame.size.width/2
        realRect.origin.y = realRect.origin.y / scrollView.zoomScale - imageView.frame.size.height/2
        realRect.size.width = (rect?.size.width)! / scrollView.zoomScale
        realRect.size.height = (rect?.size.height)! / scrollView.zoomScale
        
        let imgOrg = fixOrientation(imageView.image!)
        let img = imgOrg.cgImage!.cropping(to: realRect)
        let imgRet = UIImage(cgImage: img!)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PickedImage"), object: self, userInfo: ["image": imgRet])
    }
    
    
    
    func centerScrollViewContents() {
        // set image to scrollView center
        if let maskRect = maskView?.pickingFieldRect {
            
            let imageSize = imageView.bounds.size
            let scrollContentSize = containView.bounds.size
            
            let imgMinX = (scrollContentSize.width - imageSize.width)/2
            let imgMaxX = (scrollContentSize.width + imageSize.width)/2
            let imgMinY = (scrollContentSize.height - imageSize.height)/2
            let imgMaxY = (scrollContentSize.height + imageSize.height)/2
            
            let factor = scrollView.zoomScale
            
            if maskRect.origin.x + scrollView.contentOffset.x < imgMinX * factor {
                scrollView.contentOffset.x = imgMinX * factor - maskRect.origin.x
            } else if maskRect.origin.x + scrollView.contentOffset.x + maskRect.size.width > imgMaxX * factor {
                scrollView.contentOffset.x = imgMaxX * factor - maskRect.size.width - maskRect.origin.x
            }
            
            if maskRect.origin.y + scrollView.contentOffset.y < imgMinY * factor {
                scrollView.contentOffset.y = imgMinY * factor - maskRect.origin.y
            } else if maskRect.origin.y + scrollView.contentOffset.y + maskRect.size.height > imgMaxY * factor {
                scrollView.contentOffset.y = imgMaxY * factor - maskRect.size.height - maskRect.origin.y
            }
            
        }
    }
    
}

// MARK: - UIScrollViewDelegate

extension PhotoEditViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
}


class PhotoMaskView: UIView {
    
    var border: CGFloat = 36
    var pickingFieldRect : CGRect? = nil
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.size.width
        let height = rect.size.height
        
        // 圆形框的直径
        let pickingFieldWidth = width < height ? (width - border) : (height - border)
        
        let contextRef = UIGraphicsGetCurrentContext()!
        contextRef.saveGState()
        contextRef.setFillColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        contextRef.setLineWidth(3)
        // 计算圆形框的外切正方形的frame：
        self.pickingFieldRect = CGRect(x: (width - pickingFieldWidth) / 2, y: (height - pickingFieldWidth) / 2, width: pickingFieldWidth, height: pickingFieldWidth)
        // 创建圆形框UIBezierPath:
        let pickingFieldPath = UIBezierPath(ovalIn: self.pickingFieldRect!)
        // 创建外围大方框UIBezierPath:
        let bezierPathRect = UIBezierPath(rect: rect)
        // 将圆形框path添加到大方框path上去，以便下面用奇偶填充法则进行区域填充：
        bezierPathRect.append(pickingFieldPath)
        // 填充使用奇偶法则
        bezierPathRect.usesEvenOddFillRule = true
        bezierPathRect.fill()
        contextRef.setLineWidth(2)
        contextRef.setStrokeColor(red: 255, green: 255, blue: 255, alpha: 1)
        //        let dash: [CGFloat] = [4.0, 4.0]
        //        pickingFieldPath.setLineDash(dash, count: 2, phase: 0)
        pickingFieldPath.stroke()
        contextRef.restoreGState()
        self.layer.contentsGravity = kCAGravityCenter;
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}
