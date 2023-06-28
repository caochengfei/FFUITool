//
//  CGSize+fit.swift
//  FFUITool
//
//  Created by cofey on 2022/8/17.
//

import UIKit

public extension CGSize {
    
    func fitSize(with maxValue:CGFloat) ->CGSize{
        //短边最大1080，如果iphonex拍的3840 x 2160 视频进来内存直接爆炸
        let scale: CGFloat = width < height ? min(maxValue / width, 1) : min(maxValue / height, 1);
        return CGSize(width: width * scale, height: height * scale)
    }
    
    func fitRect(imageSize: CGSize, scaleToHeight: Bool = false) -> CGRect {
        guard imageSize.width != 0, imageSize.height != 0 else {
            ffAssert(imageSize.width != 0)
            ffAssert(imageSize.height != 0)
            return .zero
        }
        if (!scaleToHeight) {
            let maxSize = CGSize(width: abs(self.width), height: abs(self.height))
            let ratio: CGFloat = abs(imageSize.width / imageSize.height)
            let maxRatio: CGFloat = abs(maxSize.width / maxSize.height)
            var fitSize: CGSize = maxRatio > ratio ?
                CGSize(width:floor(maxSize.height * ratio), height:floor(maxSize.height)) :
                CGSize(width:floor(maxSize.width), height:floor(maxSize.width / ratio))
            let scaleW: CGFloat = fitSize.width / maxSize.width
            let scaleH: CGFloat = fitSize.height / maxSize.height
            let scale: CGFloat = max(scaleW, scaleH)
            fitSize = CGSize(width:floor(fitSize.width * scale), height:floor(fitSize.height * scale));
            
            return CGRect(x: (maxSize.width - fitSize.width) / 2, y: (maxSize.height - fitSize.height) / 2, width: fitSize.width, height: fitSize.height);
            
        } else {
            let maxSize = CGSize(width: abs(self.width), height: abs(self.height))
            let ratio: CGFloat = abs(maxSize.width / imageSize.width)
            let maxRatio: CGFloat = abs(maxSize.height / imageSize.height)
            let fitRatio = fmax(maxRatio, ratio)
            let fitSize: CGSize =
                CGSize(width: imageSize.width * fitRatio, height: imageSize.height * fitRatio)
            var x: CGFloat = 0.0, y: CGFloat = 0.0
            if fitSize.width > maxSize.width {
                x = (fitSize.width - maxSize.width) / 2.0
            } else if fitSize.height > maxSize.height {
                y = (fitSize.height - maxSize.height) / 2.0
            }
            return CGRect(origin: .zero, size: fitSize)

        }
    }
}


public extension CGFloat {
    var float: Float {
        return Float(self)
    }
}

public extension Float {
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
