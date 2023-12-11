//
//  LoadingView.swift
//  Picroll
//
//  Created by cofey on 2022/11/2.
//

import Foundation

open class LoadingView: UIView {
    
    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.dynamicGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    public lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.dynamicWhite.withAlphaComponent(0.2).cgColor
        layer.fillColor = nil
        layer.lineWidth = 3
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.nativeScale
        layer.magnificationFilter = CALayerContentsFilter.nearest
        return layer
    }()
    
    public lazy var loadingLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.dynamicWhite.cgColor
        layer.fillColor = nil
        layer.lineWidth = 3
        layer.strokeStart = 0
        layer.strokeEnd = 0.1
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.nativeScale
        layer.magnificationFilter = CALayerContentsFilter.nearest
        return layer
    }()
    
    public lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setTitle("Cancel".local, for: .normal)
        button.setTitleColor(UIColor.black.dynamicWhite, for: .normal)
        button.setTitle(title, for: .normal)
//        button.titleLabel?.font = PRTheme.fontMedium(size: 15)
        button.titleLabel?.font = titleFont
        button.adjustsImageWhenHighlighted = false
        button.clickEdgeInsets = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return button
    }()
    
    public var safeTouch: UIEdgeInsets = .zero
    
    public var title: String? {
        didSet {
            closeButton.setTitle(title, for: .normal)
        }
    }
    
    public var titleFont: UIFont? {
        didSet {
            closeButton.titleLabel?.font = titleFont
        }
    }
    
    public var progress: CGFloat = 0.1
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.layer.cornerRadius = 10
        self.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.layer.addSublayer(backgroundLayer)
        contentView.layer.addSublayer(loadingLayer)
    }
    
    public init(frame: CGRect, title: String?, titleFont: UIFont?) {
//        self.init(frame: frame)
        super.init(frame: frame)
        self.titleFont = titleFont
        self.title = title
        
        self.backgroundColor = UIColor.clear
        
        self.layer.cornerRadius = 10
        self.addSubview(contentView)
        contentView.addSubview(closeButton)
        contentView.layer.addSublayer(backgroundLayer)
        contentView.layer.addSublayer(loadingLayer)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if point.x < safeTouch.left || point.y < safeTouch.top || point.y > self.height - safeTouch.bottom || point.x > self.height - safeTouch.right {
            return nil
        }
        return super.hitTest(point, with: event)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let loadingPointY = self.title != nil ? contentView.width / 2 - 15 : contentView.height / 2
        let loadingLayerHeight = self.title != nil ? contentView.width - 30 : contentView.width
        let backgroundPath = UIBezierPath(arcCenter: CGPoint(x: contentView.width / 2, y: loadingPointY), radius: contentView.bounds.width / 4, startAngle: -CGFloat.pi / 2.0, endAngle: CGFloat.pi * 3 / 2.0, clockwise: true)
        self.backgroundLayer.frame = CGRect(origin: .zero, size: CGSize(width: contentView.width, height: loadingLayerHeight))
        self.loadingLayer.frame = backgroundLayer.frame
        self.backgroundLayer.path = backgroundPath.cgPath
        self.loadingLayer.path = backgroundPath.cgPath
        
        self.closeButton.frame = CGRect(origin: .zero, size: CGSize(width: 60, height: 40))
        self.closeButton.bottom = contentView.height - 5
        self.closeButton.centerX = contentView.width / 2
        self.ffShadow()
    }
    
    public func startAnimate() {
        self.loadingLayer.strokeEnd = 0.1
        let animation = CABasicAnimation(keyPath:"transform.rotation.z")
        animation.toValue = 2 * CGFloat.pi
        animation.duration = 1.25
        animation.repeatCount = HUGE
        self.loadingLayer.add(animation, forKey: "transform.rotationZ")
    }
    
    @objc func closeButtonAction() {
        self.removeFromSuperview()
        canceldCallback?()
    }
    
    public func endAnimate() {
        self.loadingLayer.removeAllAnimations()
    }
    
    public var canceldCallback: (()->())?
    
    public class func show(with view: UIView? = nil, safeTouch: UIEdgeInsets = .zero, canceled: (()->())? = nil) {
        LoadingView.hide(with: view)
        DispatchQueue.main.async {
            guard let view = view ?? UIApplication.shared.windows.first else {
                return
            }
            let loadingView = LoadingView(frame: CGRect(origin: .zero, size: CGSize(width: view.width, height: view.height)))
            loadingView.canceldCallback = canceled
            loadingView.tag = 233333
            loadingView.contentView.size = CGSize(width: 150, height: 150)
            loadingView.contentView.center = CGPoint(x: view.width / 2, y: view.height / 2)
            loadingView.safeTouch = safeTouch
            view.addSubview(loadingView)
            loadingView.startAnimate()
        }
    }
    
    public class func show(with view: UIView? = nil, title: String?, titleFont: UIFont?, canceled: (()->())? = nil) {
        DispatchQueue.main.async {
            guard let view = view ?? UIApplication.shared.windows.first else {
                return
            }
            view.viewWithTag(233333)?.removeFromSuperview()
            let loadingView = LoadingView(frame: CGRect(origin: .zero, size: CGSize(width: view.width, height: view.height)), title: title, titleFont: titleFont)
            loadingView.canceldCallback = canceled
            loadingView.tag = 233333
            loadingView.contentView.size = CGSize(width: 150, height: 150)
            loadingView.contentView.center = CGPoint(x: view.width / 2, y: view.height / 2)
            view.addSubview(loadingView)
            loadingView.startAnimate()
        }
    }
    
    
    public class func hide(with view: UIView? = nil) {
        DispatchQueue.main.async {
            let view = view ?? UIApplication.shared.windows.first
            let loadingView = view?.viewWithTag(233333) as? LoadingView
            setProgress(with: view, progress: 1.0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.22) {
                loadingView?.endAnimate()
                loadingView?.removeFromSuperview()
            }
        }
      
    }
    
    public class func setProgress(with view: UIView? = nil, progress: CGFloat) {
        if Thread.isMainThread {
            setProgress(with: view, progress: progress)
        } else {
            DispatchQueue.main.async {
                setProgress(with: view, progress: progress)
            }
        }
        
        func setProgress(with view: UIView? = nil, progress: CGFloat) {
            let view = view ?? UIApplication.shared.windows.first
            let loadingView = view?.viewWithTag(233333) as? LoadingView
            guard let loadingView = loadingView else {
                return
            }
            let progress = min(max(0.1, progress), 1)
            if progress > loadingView.progress {
                let animate = CABasicAnimation(keyPath: "strokeEnd")
                animate.duration = 0.2
                animate.fromValue = loadingView.progress
                animate.toValue = progress
                animate.isRemovedOnCompletion = false
                animate.fillMode = CAMediaTimingFillMode.forwards
                loadingView.loadingLayer.add(animate, forKey: "progress")
                loadingView.progress = progress
            }
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        backgroundLayer.strokeColor = UIColor.black.dynamicWhite.withAlphaComponent(0.2).cgColor
        loadingLayer.strokeColor = UIColor.black.dynamicWhite.cgColor
    }
}
