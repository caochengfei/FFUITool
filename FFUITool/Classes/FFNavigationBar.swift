//
//  FFNavigationBar.swift
//  Picroll
//
//  Created by cofey on 2022/8/30.
//

import UIKit
import SnapKit

public protocol FFNavigationBarDelegate: AnyObject {
    func naviBackButtonAction()
    func naviRightButtonAction()
}

public extension FFNavigationBarDelegate {
    func naviRightButtonAction(){}
}

open class FFNavigationBar: UIView {
    public weak var delegate: FFNavigationBarDelegate?
    
    public var itemBottomSpacing: CGFloat = 12 {
        didSet {
            setupLayout()
        }
    }
    
    public lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        //        if #available(iOS 14, *) {
        //            let image = UIImage.systedName(name: "chevron.backward", fontSize: 20, weight: UIImage.SymbolWeight.medium)
        //            button.setImage(image, for: .normal)
        //            button.tintColor = UIColor.black.dynamicWhite
        //        } else {
        //            button.setImage(UIImage(named: "back_black"), for: .normal)
        //        }
        let image = UIImage(named: "back_black")
        button.setTitleColor(UIColor.black.dynamicWhite, for: .normal)
//        button.setImage(UIImage(named: "back_black")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(image, for: .normal)
        button.setTitle(nil, for: .normal)
        button.tintColor = "#222222".toRGB.dynamicWhite
        button.adjustsImageWhenHighlighted = false
        button.clickEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        button.addZoomInAnimate()
        return button
    }()
    
    public lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        //        if #available(iOS 13, *) {
        //            let image = UIImage.systedName(name: "square.and.arrow.up", fontSize: 20, weight: UIImage.SymbolWeight.medium)
        //            button.setImage(image, for: .normal)
        //            button.tintColor = UIColor.black.dynamicWhite
        //        } else {
        //            button.setImage(UIImage(named: "share_black"), for: .normal)
        //        }
        button.setImage(UIImage(named: "share_black")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle(nil, for: .normal)
        button.tintColor = "#222222".toRGB.dynamicWhite
        button.setTitleColor(UIColor.black.dynamicWhite, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.clickEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        //        button.titleLabel?.font = PRTheme.fontBold(size: 16)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.isHidden = true
        button.addZoomInAnimate()
        return button
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = "#222222".toRGB.dynamicWhite
        //        label.font = PRTheme.fontBold(size: 16)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    public var backButtonFont: UIFont? {
        didSet {
            backButton.titleLabel?.font = backButtonFont
        }
    }
    
    public var rightButtonFont: UIFont? {
        didSet {
            rightButton.titleLabel?.font = rightButtonFont
        }
    }
    
    public var titleLabelFont: UIFont? {
        didSet {
            titleLabel.font = titleLabelFont
        }
    }
    
    public var titleView: UIView? {
        didSet {
            setupUI()
            setupLayout()
        }
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    public init(frame: CGRect, titleView: UIView? = nil, itemBottomSpacing: CGFloat = 12) {
        super.init(frame: frame)
        self.titleView = titleView
        self.itemBottomSpacing = itemBottomSpacing
        setupUI()
        setupLayout()
    }
    
    public init(frame: CGRect, itemBottomSpacing: CGFloat = 12, font: UIFont?) {
        super.init(frame: frame)
        self.itemBottomSpacing = itemBottomSpacing
        // 适配下药丸屏幕
        if UIDevice.deviceName == "iPhone 14 Pro" || UIDevice.deviceName == "iPhone 14 Pro Max" {
            self.itemBottomSpacing = 8
        }
        self.backButtonFont = font
        self.rightButtonFont = font
        self.titleLabelFont = font
        setupUI()
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupUI() {
        addSubview(backButton)
        addSubview(rightButton)
        addSubview(titleLabel)
        if let titleView = titleView {
            addSubview(titleView)
        }
    }
    
    public func setupLayout() {
        
        if #available(iOS 14, *) {
            backButton.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-itemBottomSpacing)
            }
        } else {
            backButton.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-itemBottomSpacing)
            }
        }
        
        rightButton.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(backButton)
        }
        
        self.titleView?.isHidden = true
        titleLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
            make.width.lessThanOrEqualTo(self.snp.width).multipliedBy(0.5)
        }
        
        if let titleView = titleView {
            titleView.isHidden = false
            self.titleLabel.isHidden = true
            titleView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(backButton)
                make.size.equalTo(titleView.snp.size)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateIntrinsicContentSize()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: rightButton.right + 20, height: self.height)
    }
}


//MARK: - actions
extension FFNavigationBar {
    @objc func backButtonAction() {
        delegate?.naviBackButtonAction()
    }
    
    @objc func rightButtonAction() {
        delegate?.naviRightButtonAction()
    }
    
    
}
