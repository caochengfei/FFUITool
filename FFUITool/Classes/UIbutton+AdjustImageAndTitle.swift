//
//  UIbutton+AdjustImageAndTitle.swift
//  Picroll
//
//  Created by cofey on 2023/1/5.
//

import Foundation

public enum FFContentAdjustType: Int {
    case imageLeftTitleRight = 0
    case imageRightTitleLeft
    case imageUpTitleDown
    case imageDownTitleUp
}

extension UIButton {
    
    private struct RuntimeKey {
        static let spaceKey = UnsafeRawPointer(bitPattern: "spaceKey".hashValue)
        static let contentAdjustTypeKey = UnsafeRawPointer(bitPattern: "contentAdjustTypeKey".hashValue)
    }
    
    public var ff_contentAdjustType: FFContentAdjustType? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.contentAdjustTypeKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            ff_beginAdjustContent()
        }
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.contentAdjustTypeKey!) as? FFContentAdjustType ?? .imageLeftTitleRight
        }
    }
    
    public var ff_space: CGFloat {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.spaceKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            ff_beginAdjustContent()
        }
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.spaceKey!) as? CGFloat ?? 0
        }
    }
    
    public func ff_beginAdjustContent() {
        ff_beginAdjustContentWithMaxTitleWidth(maxTitleWidth: 0)
    }
    
    public func ff_beginAdjustContentImmediately() {
        ff_beginAdjustContentWithMaxTitleWidth(maxTitleWidth: 0)
    }
    
    public func ff_beginAdjustContentWithMaxTitleWidth(maxTitleWidth: CGFloat) {
        _beginAdjustContentWithMaxTitleWidth(maxTitleWidth: maxTitleWidth)
    }
    
    private func _beginAdjustContentWithMaxTitleWidth(maxTitleWidth: CGFloat) {
        guard let image = self.imageView?.image, let title = self.titleLabel?.text, title.count > 0 else {
            return
        }
        
        let imageSize = image.size
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        let titleSize = self.titleLabel!.sizeThatFits(.zero)
        var titleWidth = titleSize.width
        let titleHeight = titleSize.height
        
        if maxTitleWidth > 0 && titleWidth < maxTitleWidth {
            titleWidth = maxTitleWidth
        }
        let space = ff_space
        
        switch self.ff_contentAdjustType {
        case .imageLeftTitleRight:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space * 0.5, bottom: 0, right: -space * 0.5)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space * 0.5, bottom: 0, right: space * 0.5)
        case .imageRightTitleLeft:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + space * 0.5), bottom: 0, right: imageWidth + space * 0.5)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth + space * 0.5, bottom: 0, right: -(titleWidth + space * 0.5))
        case .imageDownTitleUp:
            self.titleEdgeInsets = UIEdgeInsets(top: (titleHeight + space) * 0.5, left: -imageWidth * 0.5, bottom: -(titleHeight + space) * 0.5, right: imageWidth * 0.5)
            self.imageEdgeInsets = UIEdgeInsets(top: -(imageHeight + space) * 0.5, left: titleWidth * 0.5, bottom: (imageHeight + space) * 0.5, right: -titleWidth * 0.5)
        case .imageUpTitleDown:
            self.titleEdgeInsets = UIEdgeInsets(top: -(titleHeight + space) * 0.5, left: -imageWidth * 0.5, bottom: (titleHeight + space) * 0.5, right: imageWidth * 0.5)
            self.imageEdgeInsets = UIEdgeInsets(top: (imageHeight + space) * 0.5, left: titleWidth * 0.5, bottom: -(imageHeight + space) * 0.5, right: -titleWidth * 0.5)

        default:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space * 0.5, bottom: 0, right: -space * 0.5)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space * 0.5, bottom: 0, right: space * 0.5)
            break
        }
    }
}
