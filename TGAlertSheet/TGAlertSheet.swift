//
// 自定义底部弹出提示框
//

import UIKit

struct AlertSheetConfig {
    var titleEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
    var titleFontSize: CGFloat = 13.0
    var darkAlpha: CGFloat = 0.5
    var lineColor: UIColor = UIColor.lightGray
    var titleFontColor: UIColor = UIColor.gray
    var darkFontColor: UIColor = UIColor.black
    var lightFontColor: UIColor = UIColor.blue
    var specialFontColor: UIColor = UIColor.red
    var cancelFontColor: UIColor = UIColor.blue
    var highlightColor: UIColor = UIColor.gray
    var spaceHeight: CGFloat = 7.0
    var itemHeight: CGFloat = 50.0
    var itemFontSize: CGFloat = 16.0
    var animateTime: Double = 0.2
}

struct AlertSheetItem {
    enum ItemStyle {
        case dark
        case light
        case special
    }
    var title: String = ""
    var style: ItemStyle = .light
}

class AlertSheet: UIView {
    
    var didClickedItemAtIndexHandler: ((Int) -> Void)?
    var didClickedCancelHandler: ((Void) -> Void)?
    
    var config: AlertSheetConfig!
    
    fileprivate var darkView: UIView!
    fileprivate var bottomView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var titleLineView: UIView!
    fileprivate var lineView: UIView!
    fileprivate var itemsTableView: UITableView!
    fileprivate var spaceView: UIView!
    fileprivate var cancelButton: UIButton!
    
    fileprivate(set) var title: String!
    fileprivate(set) var cancelItemTitle: String!
    fileprivate(set) var otherItemTitles = [AlertSheetItem]()
    
    fileprivate var bottomViewHeight: CGFloat = 0
    
    static func actionSheet(title: String?, cancelItemTitle: String?, otherItemTitles: [AlertSheetItem]) -> AlertSheet {
        return AlertSheet(title: title, cancelItemTitle: cancelItemTitle, otherItemTitles: otherItemTitles)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(title: String?, cancelItemTitle: String?, otherItemTitles: [AlertSheetItem]) {
        super.init(frame: CGRect.zero)
        
        self.title = title
        self.cancelItemTitle = cancelItemTitle
        self.otherItemTitles = otherItemTitles
        
        self.config = AlertSheetConfig()
        
        setupViews()
        layoutWidgets(isInit: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func show() {
        
        UIView.animate(withDuration: self.config.animateTime, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            if let sSelf = self {
                sSelf.darkView.alpha = sSelf.config.darkAlpha
                sSelf.bottomView.frame.origin = CGPoint(x: 0, y: sSelf.frame.size.height - sSelf.bottomViewHeight)
            }
        }, completion: { [weak self] (finished) in
            self?.darkView.isUserInteractionEnabled = true
        })
    }
    
    public func hide() {
        
        self.darkView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: self.config.animateTime, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            if let sSelf = self {
                sSelf.darkView.alpha = 0
                sSelf.bottomView.frame.origin = CGPoint.init(x: 0, y: sSelf.frame.size.height)
            }
        }) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupViews() {
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        keyWindow.addSubview(self)
        self.frame = keyWindow.frame
        
        darkView = UIView()
        darkView.alpha = 0
        darkView.isUserInteractionEnabled = false
        darkView.backgroundColor = UIColor.black
        self.addSubview(darkView)
        
        if cancelItemTitle != nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCloseAction))
            darkView.addGestureRecognizer(tapGesture)
        }
        
        bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        self.addSubview(bottomView)
        
        if self.title != nil {
            titleLabel = UILabel()
            titleLabel.text = self.title
            titleLabel.font = UIFont.systemFont(ofSize: self.config.titleFontSize)
            titleLabel.numberOfLines = 0
            titleLabel.textColor = self.config.titleFontColor
            titleLabel.textAlignment = .center
            bottomView.addSubview(titleLabel)
        }
        
        itemsTableView = UITableView()
        itemsTableView.bounces = false
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.separatorStyle = .none
        itemsTableView.register(AlertSheetCell.self, forCellReuseIdentifier: "AlertSheetCell")
        bottomView.addSubview(itemsTableView)
        
        lineView = UIView()
        lineView.backgroundColor = self.config.lineColor
        bottomView.addSubview(lineView)
        
        if self.cancelItemTitle != nil {
            spaceView = UIView()
            spaceView.backgroundColor = self.config.lineColor
            bottomView.addSubview(spaceView)
            
            cancelButton = UIButton()
            cancelButton.addTarget(self, action: #selector(onCancelAction), for: .touchUpInside)
            cancelButton.setTitle(self.cancelItemTitle, for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: self.config.itemFontSize)
            cancelButton.setTitleColor(self.config.cancelFontColor, for: .normal)
            cancelButton.setBackgroundImage(UIImage.imageWithColor(self.config.highlightColor), for: .highlighted)
            cancelButton.contentMode = .scaleAspectFit
            bottomView.addSubview(cancelButton)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onListenOrientationChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    fileprivate func layoutWidgets(isInit: Bool) {
        
        let winSize = self.frame.size
        let maxBottomViewHeight = winSize.height * 0.8 // bottomView最大高度
        
        var titleLabelWidth: CGFloat = 0
        var titleLabelHeight: CGFloat = 0
        var titlePanelHeight: CGFloat = 0
        if self.title != nil {
            titleLabelWidth = winSize.width - self.config.titleEdgeInsets.left - self.config.titleEdgeInsets.right
            titleLabelHeight = tgc_rectSizeForLabel(textLabel: titleLabel, width: titleLabelWidth).1
            titlePanelHeight = self.config.titleEdgeInsets.top + self.config.titleEdgeInsets.bottom + titleLabelHeight
        }
        var spaceViewHeight: CGFloat = 0
        var cancelButtonHeight: CGFloat = 0
        if self.cancelItemTitle != nil {
            spaceViewHeight = self.config.spaceHeight
            cancelButtonHeight = self.config.itemHeight
        }
        
        let otherItemsContentHeight = CGFloat(self.otherItemTitles.count) * self.config.itemHeight
        var otherItemsHeight = otherItemsContentHeight
        var realBottomViewHeight = titlePanelHeight + otherItemsHeight + spaceViewHeight + cancelButtonHeight
        
        if realBottomViewHeight > maxBottomViewHeight {  // 超过最大的高度：tableView需要滑动
            otherItemsHeight = maxBottomViewHeight - titlePanelHeight - spaceViewHeight - cancelButtonHeight
            realBottomViewHeight = maxBottomViewHeight
        }
        self.bottomViewHeight = realBottomViewHeight
        
        darkView.frame.size = CGSize(width: winSize.width, height: winSize.height)
        darkView.frame.origin = CGPoint(x: 0, y: 0)
        bottomView.frame.size = CGSize(width: winSize.width, height: realBottomViewHeight)
        if isInit {
            bottomView.frame.origin = CGPoint(x: 0, y: winSize.height)
        } else {
            bottomView.frame.origin = CGPoint(x: 0, y: winSize.height - self.bottomViewHeight)
        }
        
        titleLabel?.frame = CGRect(x: self.config.titleEdgeInsets.left, y: self.config.titleEdgeInsets.top,width: titleLabelWidth, height: titleLabelHeight)
        itemsTableView.frame = CGRect(x: 0, y: titlePanelHeight, width: winSize.width, height: otherItemsHeight)
        lineView.frame = CGRect(x: 0, y: titlePanelHeight - 0.5, width: winSize.width, height: 0.5)
        spaceView?.frame = CGRect(x: 0, y: titlePanelHeight + otherItemsHeight, width: winSize.width, height: spaceViewHeight)
        cancelButton?.frame = CGRect(x: 0, y: realBottomViewHeight - cancelButtonHeight, width: winSize.width, height: cancelButtonHeight)
    }
    
    // MARK: - Callback Methods
    
    @objc fileprivate func onCloseAction(_ sender: UITapGestureRecognizer) {
        hide()
        didClickedCancelHandler?()
    }
    
    @objc fileprivate func onCancelAction(_ sender: UIButton) {
        hide()
        didClickedCancelHandler?()
    }
    
    @objc fileprivate func onListenOrientationChange(sender: Notification) {
        print("onListenOrientationChange")
        if let keyWindow = UIApplication.shared.keyWindow {
            self.frame = keyWindow.frame
        }
        layoutWidgets(isInit: false)
    }
}


// MARK: - UITableViewDataSource

extension AlertSheet: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherItemTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertSheetCell", for: indexPath) as! AlertSheetCell
        let item = self.otherItemTitles[indexPath.row]
        cell.contentLabel.text = item.title
        cell.contentLabel.font = UIFont.systemFont(ofSize: self.config.itemFontSize)
        cell.lineView.backgroundColor = self.config.lineColor
        cell.selectionColor = self.config.highlightColor
        switch item.style {
        case .dark:
            cell.contentLabel.textColor = self.config.darkFontColor
        case .light:
            cell.contentLabel.textColor = self.config.lightFontColor
        case .special:
            cell.contentLabel.textColor = self.config.specialFontColor
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlertSheet: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.didClickedItemAtIndexHandler?(indexPath.row)
        self.hide()
        //        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.config.itemHeight
    }
}

// MARK: - AlertSheetCell

class AlertSheetCell: UITableViewCell {
    
    var contentLabel: UILabel!
    var lineView: UIView!
    var selectionColor: UIColor!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentLabel = UILabel()
        contentLabel.textAlignment = .center
        contentLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail // ...结尾
        self.addSubview(contentLabel)
        
        lineView = UIView()
        lineView.contentMode = .bottom
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentLabel.frame.size = CGSize(width: self.frame.size.width - 30, height: self.frame.size.height - 8)
        contentLabel.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
        
        lineView.frame.size = CGSize(width: self.frame.size.width, height: 0.5)
        lineView.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            backgroundColor = self.selectionColor
        } else {
            backgroundColor = UIColor.white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            backgroundColor = self.selectionColor
        } else {
            backgroundColor = UIColor.white
        }
    }
}


// MARK: - UIImage extension

extension UIImage {
    
    static func imageWithColor(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 2.0, height: 2.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

// MARK: - UIView extension

extension UIView {
    
    func tgc_rectSizeForLabel(textLabel: UILabel, width: CGFloat) -> (CGFloat, CGFloat) {
        let attributes = [NSFontAttributeName: textLabel.font!]
        let rect = (textLabel.text! as NSString).boundingRect(with: CGSize(width: width, height: 0), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return (rect.width, rect.height)
    }
}
