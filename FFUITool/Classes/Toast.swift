//
//  Toast.swift
//  FFUITool
//
//  Created by cofey on 2022/9/2.
//

import Foundation

// default time
public let toastShowDefaultDuration: TimeInterval = 2.0

private let sideSpace: CGFloat = 20.px

private let maxToastWidth = kScreenWidth - sideSpace * 2.0

public enum ToastType {
    case normal
    case warning
    case error
    case feedBack
    case success
    case loading
}

public enum ToastPositionType {
    case bottom
    case center
}

public enum ToastContainerType {
    case window
    case controller
    case custom(container: UIView)
}

open class Toast: UIView {

    fileprivate static var toasts = [String]()
    
    
    public static var sharedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    @discardableResult
    public static func show(with text: String,
                            duration: TimeInterval? = toastShowDefaultDuration,
                            type: ToastType = .normal,
                            position: ToastPositionType = .bottom,
                            container: ToastContainerType = .window,
                            positionCenterY: CGFloat? = nil,
                            font: UIFont,
                            removeLast: Bool = true) -> Toast? {
        switch type {
        case .success:
            TapticEngine.successBoom()
        case .feedBack:
            TapticEngine.feedBackBoom()
        default:
            break
        }
        guard text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else { return nil }
        if !toasts.contains(text) {
            toasts.append(text)
            if removeLast {
                Toast.sharedLabel.superview?.removeFromSuperview()
            }
            let toast = Toast(text: text,
                              duration: duration,
                              and: type,
                              position: position,
                              positionCenterY: positionCenterY,
                              font: font)
            switch container {
            case .window:
                UIApplication.AppWindow?.addSubview(toast)
            case .controller:
                UIApplication.AppTop?.view.addSubview(toast)
            case .custom(let container):
                container.addSubview(toast)
            }
            toast.show()
            return toast
        }
        return nil
    }
    
    var duration: TimeInterval?
    var type: ToastType
    var text: String
    var position: ToastPositionType
    var positionCenterY: CGFloat?
    var targetFont: UIFont
    fileprivate let margin = 10.px
    
    init(text: String,
         duration: TimeInterval?,
         and type: ToastType,
         position: ToastPositionType,
         positionCenterY: CGFloat?,
         font: UIFont) {
        self.text = text
        self.type = type
        self.duration = duration
        self.position = position
        self.positionCenterY = positionCenterY
        self.targetFont = font
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = "#333333".toRGB
        isUserInteractionEnabled = false
        updateText(with: text)
        addSubview(Toast.sharedLabel)
        alpha = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hide))
        addGestureRecognizer(tap)
    }
    
    public func updateText(with text: String) {
        self.text = text
        Toast.sharedLabel.text = text
        Toast.sharedLabel.numberOfLines = 0
        var textWidth = text.textWidth(font: targetFont) + 34.px
        if textWidth > maxToastWidth {
            textWidth = maxToastWidth
        }
        let textHeight = text.textHeight(width: textWidth, font: targetFont) + 13.px
        var corner = textHeight / 2
        if corner > 15.px {
            corner = 15.px
        }
        layer.cornerRadius = corner
        let finalSize = CGSize(width: textWidth, height: textHeight)
        size = finalSize
        Toast.sharedLabel.size = finalSize
        Toast.sharedLabel.font = targetFont
        centerX = kScreenWidth / 2
        if let positionBottom = positionCenterY {
            bottom = positionBottom
        } else {
            if position == .bottom {
                bottom = kScreenHeight - 20.px
            } else {
                centerY = kScreenHeight / 2
            }
        }
        Toast.sharedLabel.center = CGPoint(x: self.width * 0.5, y: self.height * 0.5)
    }

    
    fileprivate func show() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
        }) { (bool) in
            if let duration = self.duration {
                self.perform(#selector(self.hide), with: nil, afterDelay: duration)
            }
        }
    }
    
    @objc public func hide() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
        }) { (bool) in
            Toast.toasts.removeAll { string in
                return string == self.text
            }
            self.removeFromSuperview()
        }
    }
}

public func showToast(msg: String, withCenter: Bool = false) {
    let centerY = withCenter ? UIScreen.main.bounds.height / 2 :  UIScreen.main.bounds.height - kBottomSafeHeight - 40.px
    Toast.show(with: msg,
               positionCenterY: centerY,
               font: UIFont.systemFont(ofSize: 15))
}



