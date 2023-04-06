//
//  FloatingView.swift
//  Picroll
//
//  Created by cofey on 2022/10/19.
//

import Foundation

public protocol FloatingViewProtocol: AnyObject {
    func floatingView(view: FloatingView, willRemove: Bool)
    func floatingView(view: FloatingView, didSelected: Bool)
    func floatingViewWillEdit(view: FloatingView)
    func floatingViewPositionDidChanged(view: FloatingView)
}

extension FloatingViewProtocol {
    public func floatingView(view: FloatingView, willRemove: Bool) {}
    public func floatingView(view: FloatingView, didSelected: Bool) {}
    public func floatingViewWillEdit(view: FloatingView) {}
    public func floatingViewPositionDidChanged(view: FloatingView) {}
}

open class FloatingView: UIView {
    
    public var id: String = UUID().uuidString
    
    public weak var delegate: FloatingViewProtocol?
                
    /// 是否需要平移
    open var isNeedPan: Bool = true {
        didSet {
            configGestures()
        }
    }
    
    /// 是否需要缩放
    open var isNeedPinch: Bool = true {
        didSet {
            configGestures()
        }
    }
    
    /// 是否需要旋转
    open var isNeedRotate: Bool = true {
        didSet {
            configGestures()
        }
    }
    
    open var isNeedTap: Bool = true {
        didSet {
            configGestures()
        }
    }
    
    var lastRotation: CGFloat = 0
    
    open var isSelected: Bool = false {
        didSet {
            self.layer.borderWidth = isSelected ? 2 : 0
            self.pinchGesture.isEnabled = isSelected
            self.panGesture.isEnabled = isSelected
            self.rotationGesture.isEnabled = isSelected
            edgeButtons?.forEach({$0.isHidden = !isSelected})
            if isSelected == false {
                deleteButton.isHidden = true
            }
        }
    }
    
    open var isShowDelete: Bool = false {
        didSet {
            deleteButton.isHidden = !isShowDelete
        }
    }
    
    
    public enum EdgePositionEnum: Int {
        case leftTop = 10000
        case rightTop = 10001
        case leftBottom = 10002
        case rightBottom = 10003
    }
    
    open var edgeImages = [EdgePositionEnum : UIImage?]() {
        didSet {
            addButtonIfNeed(tag: .leftTop, image: edgeImages[.leftTop] as? UIImage)
            addButtonIfNeed(tag: .rightTop, image: edgeImages[.rightTop] as? UIImage)
            addButtonIfNeed(tag: .leftBottom, image: edgeImages[.leftBottom] as? UIImage)
            addButtonIfNeed(tag: .rightBottom, image: edgeImages[.rightBottom] as? UIImage)
        }
    }
    
    func addButtonIfNeed(tag: EdgePositionEnum, image: UIImage?) {
        guard let button: UIButton = self.viewWithTag(tag.rawValue) as? UIButton else {
            let button = UIButton(type: .custom)
            button.adjustsImageWhenHighlighted = false
            button.setImage(image, for: .normal)
            button.tag = tag.rawValue
//            button.clickEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
            button.size = CGSize(width: 36, height: 36)
            button.addTarget(self, action: #selector(ltButtonClick), for: .touchUpInside)
            self.addSubview(button)
            button.isHidden = true
            return
        }
        if image == nil {
            button.removeFromSuperview()
            return
        }
        button.setImage(image, for: .normal)
    }
    
    @objc func ltButtonClick() {
        
    }
    
    /// 是否等比缩放.默认yes
    open var scaleFit: Bool = true
    
    open var pinchScale: CGFloat = 1.0
    
    open var image: UIImage?
    /// 显示内容 uiview/uitextview/uiimageview 等
    open var contentView: UIView? {
        didSet {
            let center = self.center
            oldValue?.removeFromSuperview()
            self.transform = CGAffineTransform.identity
            contentView?.isUserInteractionEnabled = false
            
            if let contentView = contentView {
                contentView.size = CGSize(width: contentView.width * pinchScale, height: contentView.height * pinchScale)
                self.frame = contentView.frame
                self.center = center
                contentView.frame = self.bounds
                contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.insertSubview(contentView, at: 0)
                self.transform = CGAffineTransform.init(rotationAngle: lastRotation)
            }
        }
    }
    
    //MARK: - Lazy var
    open lazy var pinchGesture: UIPinchGestureRecognizer = {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_ :)))
        pinch.delegate = self
        return pinch
    }()
    
    open lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        pan.delegate = self
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 2
        return pan
    }()
    
    open lazy var rotationGesture: UIRotationGestureRecognizer = {
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationAction(_ :)))
        rotation.delegate = self
        return rotation
    }()
    
    open lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_ :)))
        tapGesture.delegate = self
        return tapGesture
    }()
    
    open lazy var longGesture: UILongPressGestureRecognizer = {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longAction(_ :)))
        longGesture.minimumPressDuration = 0.4
        return longGesture
    }()
    
    public lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Delete", for: .normal)
        button.clickEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        button.size = CGSize(width: 72, height: 43)
        button.titleEdgeInsets = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
        button.layer.addSublayer(deleteButtonLayer)
        button.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        button.isHidden = true
        return button
    }()
    
    lazy var deleteButtonLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = "#1D1D1D".uicolor(alpha: 0.94).cgColor
//        layer.borderColor = UIColor.red.cgColor
//        layer.borderWidth = 1
        return layer
    }()
    
    
    open var originalPoint: CGPoint = .zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isExclusiveTouch = true
        configGestures()
        addSubview(deleteButton)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func containsPoint(point: CGPoint) -> UIView? {
        if self.isShowDelete == true {
            let p = deleteButton.convert(point, from: self)
            if deleteButton.bounds.contains(p) {
                return deleteButton
            } else if self.bounds.contains(point) {
                return self
            }
        } else {
            if self.bounds.contains(point) {
                return self
            }
        }
        return nil
    }
    
    public func configGestures() {
        if self.isNeedPan {
            if self.gestureRecognizers?.contains(self.panGesture) != true {
                self.addGestureRecognizer(self.panGesture)
            }
        } else {
            if self.gestureRecognizers?.contains(self.panGesture) == true {
               self.removeGestureRecognizer(self.panGesture)
            }
        }
        
        if self.isNeedPinch {
            if self.gestureRecognizers?.contains(self.pinchGesture) != true {
                self.addGestureRecognizer(self.pinchGesture)
            }
        } else {
            if self.gestureRecognizers?.contains(self.pinchGesture) == true {
                self.removeGestureRecognizer(self.pinchGesture)
            }
        }
        
        if self.isNeedRotate {
            if self.gestureRecognizers?.contains(self.rotationGesture) != true {
                self.addGestureRecognizer(self.rotationGesture)
            }
        } else {
            if self.gestureRecognizers?.contains(self.rotationGesture) == true {
                self.removeGestureRecognizer(self.rotationGesture)
            }
        }
        
        if self.isNeedTap {
            if self.gestureRecognizers?.contains(self.tapGesture) != true {
                self.addGestureRecognizer(self.tapGesture)
            }
        } else {
            self.removeGestureRecognizer(self.tapGesture)
        }
        self.addGestureRecognizer(longGesture)
//        longGesture.require(toFail: tapGesture)
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == nil {
            let count = self.subviews.count
            for i in (0..<count).reversed() {
                let subView = self.subviews[i]
                let p = subView.convert(point, from: self)
                if subView.bounds.contains(p) {
                    if subView.isHidden {
                        continue
                    }
                    return subView
                }
            }
        }
        if view == self, self.isHidden == false {
            return view
        }
        self.isSelected = false
        return nil
    }
    
    @objc func deleteButtonClick() {
        delegate?.floatingView(view: self, willRemove: true)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        deleteButton.size = CGSize(width: 72, height: 43)
        deleteButton.bottom = 0
        deleteButton.centerX = self.width / 2
        
        let r = deleteButton.height * 0.8 * 0.2
        let size = deleteButton.size
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x:r , y: 0))
        path.addLine(to: CGPoint(x: size.width - r, y: 0))
        path.addQuadCurve(to: CGPoint(x: size.width, y: r), controlPoint: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height * 0.8 - r))
        path.addQuadCurve(to: CGPoint(x: size.width - r, y: size.height * 0.8), controlPoint: CGPoint(x: size.width, y: size.height * 0.8))
        path.addLine(to: CGPoint(x: size.width * 0.65, y: size.height * 0.8))
        path.addLine(to: CGPoint(x: size.width * 0.5, y: size.height))
        path.addLine(to: CGPoint(x: size.width * 0.35, y: size.height * 0.8))
        path.addLine(to: CGPoint(x: r, y: size.height * 0.8))
        path.addQuadCurve(to: CGPoint(x: 0, y: size.height * 0.8 - r), controlPoint: CGPoint(x: 0, y: size.height * 0.8))
        path.addLine(to: CGPoint(x: 0, y: r))
        path.addQuadCurve(to: CGPoint(x: r, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        deleteButtonLayer.path = path.cgPath
        
        if let btn = self.viewWithTag(EdgePositionEnum.leftTop.rawValue) {
            btn.center = CGPoint(x: 1, y: 1)
        }
        
        if let btn = self.viewWithTag(EdgePositionEnum.rightTop.rawValue) {
            btn.center = CGPoint(x: self.bounds.width - 1, y: 1)
        }
        
        if let btn = self.viewWithTag(EdgePositionEnum.leftBottom.rawValue) {
            btn.center = CGPoint(x: 1, y: self.bounds.height - 1)
        }
        
        if let btn = self.viewWithTag(EdgePositionEnum.rightBottom.rawValue) {
            btn.center = CGPoint(x: self.bounds.width - 1, y: self.bounds.height - 1)
        }
    }
}

extension FloatingView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer.view == self {
            let p = touch.location(in: self)
            //TODO: topleft topright bottomleft bottomright ctr
            return true
        }
        return true
    }
    
    var edgeButtons: [UIButton]? {
        let array = self.subviews.compactMap { view in
            if let button = view as? UIButton {
                if button.tag == EdgePositionEnum.leftTop.rawValue ||
                    button.tag == EdgePositionEnum.rightTop.rawValue ||
                    button.tag == EdgePositionEnum.leftBottom.rawValue ||
                    button.tag == EdgePositionEnum.rightBottom.rawValue  {
                    return button
                }
            }
            return nil
        }
        return array as? [UIButton]
    }
    
    @objc public func pinchAction(_ pinch: UIPinchGestureRecognizer) {
        let touchCount = pinch.numberOfTouches
        if touchCount <= 1 {
            return
        }
        let p1 = pinch.location(ofTouch: 0, in: self)
        let p2 = pinch.location(ofTouch: 1, in: self)
        let newPoint = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
        self.originalPoint = CGPoint(x: newPoint.x / self.bounds.size.width, y: newPoint.y / self.bounds.size.height)
        
        var oPoint = self.convert(self.realOriginalPoint, to: self.superview)
        self.center = oPoint
        
        let scale = pinch.scale
        
        // bounds target
        self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width * scale, height: self.bounds.size.height * scale)
        self.contentView?.mask?.frame = self.contentView?.bounds ?? .zero
        
//        NSLog(@"count:%lu",(unsigned long)self.contentView.subviews.count);
        if let view = self.contentView?.subviews.first {
            let center = view.center
            view.bounds = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.size.width * scale, height: view.bounds.size.height * scale)
            view.center = CGPoint(x: center.x * scale, y: center.y * scale)
        }
        
        //TODO: transform target
        
        // change center
        oPoint = self.convert(self.realOriginalPoint, to: self.superview)
        self.center = CGPoint(x: self.center.x + (self.center.x - oPoint.x), y: self.center.y + (self.center.y - oPoint.y))
        
        pinch.scale = 1
        pinchScale = (contentView?.width ?? 1) / (image?.size.width ?? 1)
    }
    
    @objc open func panAction(_ pan: UIPanGestureRecognizer) {
        let pt = pan.translation(in: self.superview)
        self.center = CGPoint(x: self.center.x  + pt.x, y: self.center.y + pt.y)
        pan.setTranslation(.zero, in: self.superview)
        delegate?.floatingViewPositionDidChanged(view: self)
    }
    
    @objc public func rotationAction(_ rotation: UIRotationGestureRecognizer) {
        let touchCount = rotation.numberOfTouches
        if touchCount <= 1 {
            return
        }
        
        let p1 = rotation.location(ofTouch: 0, in: self)
        let p2 = rotation.location(ofTouch: 1, in: self)
        let newPoint = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
        self.originalPoint = CGPoint(x: newPoint.x / self.bounds.size.width, y: newPoint.y / self.bounds.size.height)
        
        var oPoint = self.convert(self.realOriginalPoint, to: self.superview)
        self.center = oPoint
        
        lastRotation += rotation.rotation
        self.transform = self.transform.rotated(by: rotation.rotation)
        rotation.rotation = 0
        
        oPoint = self.convert(self.realOriginalPoint, to: self.superview)
        self.center = CGPoint(x: self.centerX + (self.centerX - oPoint.x), y: self.centerY + (self.centerY - oPoint.y))
    }
    
    @objc public func tapAction(_ tap: UITapGestureRecognizer) {
        if self.isSelected == true, isShowDelete == false {
            self.delegate?.floatingViewWillEdit(view: self)
            return
        }
        delegate?.floatingView(view: self, didSelected: true)
    }
    
    @objc public func longAction(_ long: UILongPressGestureRecognizer) {
        if long.state == .began {
            if self.isSelected == true {
                self.isShowDelete = true
            }
        }
    }
    
    
    public var realOriginalPoint: CGPoint {
        return CGPoint(x: self.bounds.size.width * self.originalPoint.x, y: self.bounds.size.height * self.originalPoint.y)
    }
}


extension FloatingView {
    /// 等比缩放
}
