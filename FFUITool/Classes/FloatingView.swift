//
//  FloatingView.swift
//  Picroll
//
//  Created by cofey on 2022/10/19.
//

import Foundation

open class FloatingView: UIView {
    
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
    
    open var isSelected: Bool = false {
        didSet {
            self.layer.borderWidth = isSelected ? 1 : 0
            self.pinchGesture.isEnabled = isSelected
            self.panGesture.isEnabled = isSelected
            self.rotationGesture.isEnabled = isSelected
        }
    }
    
    /// 是否等比缩放.默认yes
    open var scaleFit: Bool = true
    
    /// 显示内容 uiview/uitextview/uiimageview 等
    open var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            self.transform = CGAffineTransform.identity
            contentView?.isUserInteractionEnabled = false
            
            if let contentView = contentView {
                self.frame = contentView.frame
                contentView.frame = self.bounds
                contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.insertSubview(contentView, at: 0)
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
    
    open var originalPoint: CGPoint = .zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configGestures()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configGestures() {
        if self.isNeedPan && self.gestureRecognizers?.contains(self.panGesture) != true {
            self.addGestureRecognizer(self.panGesture)
        }
        
        if self.isNeedPinch && self.gestureRecognizers?.contains(self.pinchGesture) != true {
            self.addGestureRecognizer(self.pinchGesture)
        }
        
        if self.isNeedRotate && self.gestureRecognizers?.contains(self.rotationGesture) != true {
            self.addGestureRecognizer(self.rotationGesture)
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
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
        return nil
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
    }
    
    @objc public func panAction(_ pan: UIPanGestureRecognizer) {
        let pt = pan.translation(in: self.superview)
        self.center = CGPoint(x: self.center.x  + pt.x, y: self.center.y + pt.y)
        pan.setTranslation(.zero, in: self.superview)
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
        
        self.transform = self.transform.rotated(by: rotation.rotation)
        rotation.rotation = 0
        
        oPoint = self.convert(self.realOriginalPoint, to: self.superview)
        self.center = CGPoint(x: self.centerX + (self.centerX - oPoint.x), y: self.centerY + (self.centerY - oPoint.y))
    }
    
    
    public var realOriginalPoint: CGPoint {
        return CGPoint(x: self.bounds.size.width * self.originalPoint.x, y: self.bounds.size.height * self.originalPoint.y)
    }
}


extension FloatingView {
    /// 等比缩放
}
