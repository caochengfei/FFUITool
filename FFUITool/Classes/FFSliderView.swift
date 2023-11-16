//
//  FFSliderView.swift
//  Picroll
//
//  Created by cofey on 2022/9/5.
//

import Foundation
import SnapKit

public typealias SliderValueChange = (_ value: Float, _ minValue: Float, _ maxValue: Float)->()
public typealias SliderValueChangeEnded = (_ value: Float)->()

open class FFSliderValueView: UIView {
    public var value: CGFloat = 0 {
        didSet {
            label.text = String(format: "%.0f", value)
        }
    }
    
    public lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = "#19B2FF".toRGB
        label.font = UIFont(name: "", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.dynamicGray6.cgColor
        return layer
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.size = CGSize(width: 50, height: 40)
        layer.addSublayer(shapeLayer)
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-2.5)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateIntrinsicContentSize()
        updateLayerPath()
    }
    
    public func updateLayerPath() {
        let path = CGMutablePath()
        path.addRoundedRect(in: CGRect(origin: .zero, size: CGSize(width: 50, height: 35)), cornerWidth: 4, cornerHeight: 4)
        path.move(to: CGPoint(x: 20, y: 35))
        path.addLine(to: CGPoint(x: 25, y: 40))
        path.addLine(to: CGPoint(x: 30, y: 35))
        path.addLine(to: CGPoint(x: 20, y: 35))
        
        shapeLayer.path = path
        ffShadow(path: path)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 40)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class FFSlider: UISlider {
    public var thumbRect: CGRect = .zero
    
    public override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        self.thumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        return self.thumbRect
    }
}

open class FFSliderView: UIView {
    public var sliderDidChange: SliderValueChange?
    public var sliderDidEnded: SliderValueChangeEnded?
    public var leftImageView: UIImageView!
    public var rightImageView: UIImageView!
    public var slider: FFSlider!

    public var maxValue: Float = 100 {
        didSet {
            slider.maximumValue = maxValue
        }
    }
    
    public var minValue: Float = 0 {
        didSet {
            slider.minimumValue = minValue
        }
    }
    
    public var value: Float {
        set {
            slider.value = newValue
        }
        get {
            return slider.value
        }
    }
    
    public func setValue(value: Float, animated: Bool) {
        slider.setValue(value, animated: animated)
    }
    
    public var showSliderValueView: Bool = false {
        didSet {
            if showSliderValueView {
                sliderValueView = FFSliderValueView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 40)))
                sliderValueView?.isHidden = true
                self.addSubview(sliderValueView!)
                sliderValueView?.snp.makeConstraints({ make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(slider.snp.top).offset(-5)
                })
            } else {
                sliderValueView?.removeFromSuperview()
                sliderValueView = nil
            }
        }
    }
    
    public var sliderValueView: FFSliderValueView?
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupUI() {
        leftImageView = UIImageView()
        leftImageView.tintColor = UIColor.black.dynamicWhite
        addSubview(leftImageView)
     
        
        rightImageView = UIImageView()
        rightImageView.tintColor = UIColor.black.dynamicWhite
        addSubview(rightImageView)
       
        
        slider = FFSlider(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.value = value
        slider.minimumTrackTintColor = "#19B2FF".toRGB
        slider.addTarget(self, action: #selector(sliderValueChange(_ :)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderValueChangeEnded(_ :)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderValueChangeEnded(_ :)), for: .touchCancel)
        slider.addTarget(self, action: #selector(sliderValueChangeEnded(_ :)), for: .touchUpOutside)
        
        if let thumbImage = SliderThumbView.init(frame: CGRect(x: 0, y: 0, width: 18, height: 18)).snapShot(opaque: false) {
            slider.setThumbImage(thumbImage, for: .normal)
        }
        addSubview(slider)
    }
    
    public func setupLayout() {
        leftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        rightImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        slider.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).offset(10.rem)
            make.centerY.equalTo(leftImageView)
            make.right.equalTo(rightImageView.snp.left).offset(-10.rem)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        invalidateIntrinsicContentSize()
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: self.width, height: leftImageView.height)
    }
    
    public func setThumbImage(image: UIImage?) {
        slider.setThumbImage(image, for: .normal)
    }
    
    @objc func sliderValueChange(_ slider: FFSlider) {
        sliderDidChange?(slider.value,slider.minimumValue,slider.maximumValue)
        sliderValueView?.isHidden = false
        sliderValueView?.value = CGFloat(slider.value)
        ffPrint(slider.thumbRect)
        sliderValueView?.snp.remakeConstraints({ make in
            make.centerX.equalTo(slider.thumbRect.midX + 8 + leftImageView.right)
            make.bottom.equalTo(slider.snp.top).offset(-3)
        })
    }
    
    @objc func sliderValueChangeEnded(_ slider: UISlider) {
        sliderDidEnded?(slider.value)
        sliderValueView?.isHidden = true
    }
}

private class SliderThumbView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layer = CAShapeLayer()
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.strokeColor = "#19B2FF".toRGB.cgColor
        layer.lineWidth = 3
        layer.path = CGPath(roundedRect: CGRect(x: 1.5, y: 1.5, width: self.width - 3, height: self.height - 3), cornerWidth: self.width * 0.5, cornerHeight: self.width * 0.5, transform: nil)
        layer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func snapShot(opaque: Bool = false) -> UIImage? {
        autoreleasepool {
            let bounds = bounds == .zero ? self.bounds : bounds
            let format = UIGraphicsImageRendererFormat()
            format.opaque = opaque
            let render = UIGraphicsImageRenderer(bounds: bounds, format: format)
            let image = render.image { context in
                self.layer.render(in: context.cgContext)
            }
            return image
        }
        
    }
}
