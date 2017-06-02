//
//  TGDropBoxView.swift
//
//  Created by guang xu on 16/11/22.
//  Copyright © 2016年 guang xu. All rights reserved.
//

import UIKit


let TGDropBoxDefaultColor: UIColor = UIColor.lightGray
let TGDropBoxTitleColor: UIColor = UIColor.black
let TGDropBoxListBGColor: UIColor = UIColor.white
let TGDropBoxListTitleColor: UIColor = UIColor.black
let TGDropBoxListCellHeight: CGFloat = 35.0
let TGDropBoxBackgroundAlpha: CGFloat = 0.3
let TGDropBoxTitleMargin: CGFloat = 15
let TGDropBoxTitleFontSize: CGFloat = 14
let TGDropBoxTitleHoldFontSize: CGFloat = 13
let TGDropBoxListFontSize: CGFloat = 13
let TGDropBoxAnimateTime: Double = 0.3

class TGDropBoxView: UIView {

    // 当前是否展开了
    private(set) var isShow: Bool = false
    // 即将展示或隐藏完成后回调，形参true:展示；false:隐藏
    var willShowOrHideBoxListHandler: ((Bool) -> Void)?
    // 完成展示或隐藏完成后回调，形参true:展示；false:隐藏
    var didShowOrHideBoxListHandler: ((Bool) -> Void)?
    // 选择中了某个项回调，形参0~n-1
    var didSelectBoxItemHandler: ((Int) -> Void)?
    // 展开时是否高亮
    var isHightWhenShowList: Bool = false {
        willSet(newValue) {
            self.backgroundView?.backgroundColor = (newValue == true) ? UIColor.black : UIColor.clear
        }
    }

    fileprivate var currentIndex = -1
    fileprivate var items: [String]!

    fileprivate var boxButton: UIButton!
    fileprivate var boxTitle: UILabel!
    fileprivate var spaceLine: UIView!
    fileprivate var boxArrow: UIImageView!
    fileprivate var boxWrapperView: UIView! // add to parentVC.view
    fileprivate var backgroundView: UIView! // under the box background
    fileprivate var listTableView: UITableView!

    init(parentVC: UIViewController, title: String, items: [String], frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white
        self.items = items

        self.boxButton = UIButton(frame: frame)
        self.boxButton.addTarget(self, action: #selector(onboxButtonAction), for: .touchUpInside)
        self.addSubview(self.boxButton)

        self.boxTitle = UILabel(frame: frame)
        self.boxTitle.text = title
        self.boxTitle.font = UIFont.systemFont(ofSize: TGDropBoxTitleHoldFontSize)
        self.boxTitle.textAlignment = .left
        self.boxTitle.textColor = TGDropBoxDefaultColor
        self.boxButton.addSubview(self.boxTitle)

        self.spaceLine = UIView()
        self.spaceLine.backgroundColor = UIColor.lightGray
        self.addSubview(self.spaceLine)

        self.boxArrow = UIImageView(image: UIImage(named: "ic_more_down"))
        self.boxButton.addSubview(self.boxArrow)

        let parentFrame = parentVC.view!.frame
        self.boxWrapperView = UIView(frame: parentFrame)
        self.boxWrapperView.backgroundColor = UIColor.clear
        self.boxWrapperView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]

        self.backgroundView = UIView(frame: parentFrame)
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]

        let backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onHideBoxList))
        self.backgroundView.addGestureRecognizer(backgroundTapRecognizer)

        self.listTableView = UITableView()
        self.listTableView.backgroundColor = UIColor.clear
        self.listTableView.separatorStyle = .none
        self.listTableView.tableFooterView = UIView()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.bounces = false

        self.boxWrapperView.addSubview(self.backgroundView)
        self.boxWrapperView.addSubview(self.listTableView)
        parentVC.view.addSubview(self.boxWrapperView)

        self.boxWrapperView.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.boxButton.frame = self.frame
        self.boxButton.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)

        self.boxTitle.frame.size = CGSize(width: self.frame.size.width - 72, height: self.frame.size.height)
        self.boxTitle.frame.origin = CGPoint(x: TGDropBoxTitleMargin, y: 0)

        self.spaceLine.frame.size = CGSize(width: 1, height: self.frame.size.height - 15)
        self.spaceLine.center = CGPoint(x: self.frame.size.width - 42.5, y: self.frame.size.height * 0.5)

        self.boxArrow.sizeToFit()
        self.boxArrow.center = CGPoint(x: self.frame.size.width - 21, y: self.frame.size.height * 0.5)

        self.listTableView.frame.origin = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height)
        self.listTableView.frame.size = CGSize(width: self.frame.size.width, height: CGFloat(self.items.count) * TGDropBoxListCellHeight)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func currentTitle() -> String {
        return self.boxTitle.text!
    }

    // MARK: - Private Methods

    @objc fileprivate func onboxButtonAction(_ sender: UIButton) {
        (self.isShow == true) ? self.hideBoxList() : self.showBoxList()
    }

    @objc fileprivate func onHideBoxList(_ sender: UITapGestureRecognizer) {
        self.hideBoxList()
    }

    fileprivate func showBoxList() {

        self.boxWrapperView.isHidden = false
        if self.isHightWhenShowList == true {
            self.backgroundView.alpha = 0
        }

        self.rotateBoxArrow()
        self.isShow = true

        self.boxWrapperView.superview?.bringSubview(toFront: self.boxWrapperView)

        self.willShowOrHideBoxListHandler?(true)

        UIView.animate(
            withDuration: TGDropBoxAnimateTime,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                if self.isHightWhenShowList == true {
                    self.backgroundView.alpha = TGDropBoxBackgroundAlpha
                }
                self.listTableView.frame.size.height = CGFloat(self.items.count) * TGDropBoxListCellHeight
        }, completion: { _ in
            self.didShowOrHideBoxListHandler?(true)
        })
    }

    fileprivate func hideBoxList() {

        if self.isHightWhenShowList == true {
            self.backgroundView.alpha = TGDropBoxBackgroundAlpha
        }
        self.rotateBoxArrow()
        self.isShow = false

        self.willShowOrHideBoxListHandler?(false)

        UIView.animate(
            withDuration: TGDropBoxAnimateTime,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                if self.isHightWhenShowList == true {
                    self.backgroundView.alpha = 0
                }
                self.listTableView.frame.size.height = 0
            },
            completion: { _ in
                self.boxWrapperView.isHidden = true
                self.didShowOrHideBoxListHandler?(false)
            }
        )
    }

    fileprivate func rotateBoxArrow() {
        let angle: CGFloat = ((self.isShow) ? -179.9 : 179.9)
        UIView.animate(withDuration: 0.2, animations: {
            self.boxArrow.transform = self.boxArrow.transform.rotated(by: angle * CGFloat(M_PI/180))
        }) 
    }

    fileprivate func didSelectItem(row: Int) {
        if currentIndex == -1 {
            self.boxTitle.textColor = TGDropBoxTitleColor
            self.boxTitle.font = UIFont.systemFont(ofSize: TGDropBoxTitleFontSize)
        }

        currentIndex = row
        self.boxTitle.text = self.items[currentIndex]
        self.hideBoxList()

        self.didSelectBoxItemHandler?(row)
    }
}

extension TGDropBoxView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.didSelectItem(row: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TGDropBoxListCellHeight
    }
}

extension TGDropBoxView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TGDropBoxTableViewCell(reuseIdentifier: "Cell")
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
}


class TGDropBoxTableViewCell: UITableViewCell {

    var bottomLine: UIView!

    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = TGDropBoxListBGColor
        self.textLabel!.textColor = TGDropBoxListTitleColor
        self.textLabel!.font = UIFont.systemFont(ofSize: TGDropBoxListFontSize)
        self.textLabel!.textAlignment = .left
        self.textLabel!.frame.origin.x = TGDropBoxTitleMargin

        bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        self.addSubview(bottomLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
    }
}
