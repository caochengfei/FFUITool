//
//  UIScrollView+Snapshot.swift
//  FFUITool
//
//  Created by cofey on 2023/2/1.
//

import Foundation

extension UIScrollView {
    /// WKWebView 长截图,采用滚动offSet的形式, 单张图片拼接,解决了position:flexd重叠问题
    /// - Parameters:
    ///   - webView: WKWebView
    ///   - captureComplated: uiimage?
    public func ff_takeSnapshotWebViewScroll(scrollView: UIScrollView, progressHandle: ((_ progress: CGFloat)->())? = nil, captureComplated: @escaping (( _ image: UIImage?)->())) {
        guard let snapShotView = scrollView.snapshotView(afterScreenUpdates: true) else {
            captureComplated(nil)
            return
        }
        snapShotView.frame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: snapShotView.frame.size.width, height: snapShotView.frame.size.height)
        scrollView.superview?.addSubview(snapShotView)
        
        let scrollOffset = scrollView.contentOffset
        
        let maxIndex = floor(scrollView.contentSize.height / scrollView.bounds.height)
                
        var scale: CGFloat = 1.0
        let contentMemorySize = scrollView.contentSize.width * scrollView.contentSize.height * CGFloat(UIScreen.main.scale) * 4
        let maxMemorySize: CGFloat = 80 * 1024 * 1024 / UIScreen.main.scale
        if contentMemorySize > maxMemorySize {
            scale = maxMemorySize / contentMemorySize
        }
        scrollView.setContentOffset(.zero, animated: false)
        
        var resultImage: UIImage?
        self.contentScroll(scrollView: scrollView, pageDrawIndex: 0, maxIndex: Int(maxIndex), scale: scale, resultImage: &resultImage, progressHandle: progressHandle) { image in
            scrollView.setContentOffset(scrollOffset, animated: false)
            captureComplated(image)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                snapShotView.removeFromSuperview()
            }
        }
        
    }
    
    private func contentScroll(scrollView: UIScrollView, pageDrawIndex: Int, maxIndex: Int, scale: CGFloat, resultImage: inout UIImage?,progressHandle: ((_ progress: CGFloat)->())? = nil, drawCallback: @escaping (UIImage?)->()) {
        scrollView.setContentOffset(CGPoint(x: 0, y: pageDrawIndex * Int(scrollView.frame.size.height)), animated: false)
        let pageSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
        let splitRect = CGRect(origin: CGPoint(x: 0, y: CGFloat(pageDrawIndex) * scrollView.frame.size.height), size: pageSize)
        var resultImage = resultImage
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            UIGraphicsBeginImageContextWithOptions(pageSize, true, UIScreen.main.scale)
            scrollView.drawHierarchy(in: CGRect(origin: .zero, size: pageSize), afterScreenUpdates: false)
            let image = UIGraphicsGetImageFromCurrentImageContext()?.resized(with: pageSize.width * scale)
            UIGraphicsEndImageContext()
            if let image = image {
                if resultImage == nil {
                    resultImage = image
                } else {
                    if pageDrawIndex >= maxIndex {
                        let scaleH = (scrollView.contentSize.height - splitRect.minY) / pageSize.height
                        let newImage = image.cropImage(boxRect: CGRect(x: 0, y: 0, width: 1.0, height: scaleH), scale: image.scale)
                        resultImage = resultImage?.append(image: newImage)
                    }
                    else {
                        resultImage = resultImage?.append(image: image)
                    }
                }
            }
            
            progressHandle?(CGFloat(CGFloat(pageDrawIndex) / CGFloat(maxIndex)))
            if pageDrawIndex < maxIndex {
                self.contentScroll(scrollView: scrollView, pageDrawIndex: pageDrawIndex + 1, maxIndex: maxIndex, scale: scale, resultImage: &resultImage, progressHandle: progressHandle,drawCallback: drawCallback)
            } else {
                drawCallback(resultImage)
            }
        }
    }
}