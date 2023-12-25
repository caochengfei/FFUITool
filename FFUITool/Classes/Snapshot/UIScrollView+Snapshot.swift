//
//  UIScrollView+Snapshot.swift
//  FFUITool
//
//  Created by cofey on 2023/2/1.
//

import Foundation

extension UIScrollView {
    
    
    public func ff_takeSnapshotWebViewScroll(scrollView: UIScrollView, progressHandle: ((_ progress: CGFloat)->())? = nil) async throws -> UIImage {
        try await withUnsafeThrowingContinuation { (ct:UnsafeContinuation<UIImage, Error>) in
            ff_takeSnapshotWebViewScroll(scrollView: scrollView, progressHandle: progressHandle) { image in
                if let image = image {
                    ct.resume(returning: image)
                } else {
                    ct.resume(throwing: NSError(domain: "takeSnapshotImage error webview: \(scrollView.self)", code: 0))
                }
            }
        }
    }
    
    /// WKWebView 长截图,采用滚动offSet的形式, 单张图片拼接,解决了position:flexd重叠问题
    /// - Parameters:
    ///   - webView: WKWebView
    ///   - captureComplated: uiimage?
    public func ff_takeSnapshotWebViewScroll(scrollView: UIScrollView, progressHandle: ((_ progress: CGFloat)->())? = nil, captureComplated: @escaping (( _ image: UIImage?)->())) {
        guard let snapShotView = scrollView.snapshotView(afterScreenUpdates: true) else {
            captureComplated(nil)
            return
        }
        if scrollView.bounds.height == 0 {
            return
        }
        
        snapShotView.frame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: snapShotView.frame.size.width, height: snapShotView.frame.size.height)
        scrollView.superview?.addSubview(snapShotView)
        
        let scrollOffset = scrollView.contentOffset
        
        let maxIndex = floor(scrollView.contentSize.height / scrollView.bounds.height)
                
        var scale: CGFloat = 1.0
        let contentMemorySize = scrollView.contentSize.width * scrollView.contentSize.height * CGFloat(UIDevice.deviceScale) * 4
        let maxMemorySize: CGFloat = 80 * 1024 * 1024 / UIDevice.deviceScale
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
        let viewHeight: CGFloat = floor(scrollView.frame.size.height)
        scrollView.setContentOffset(CGPoint(x: 0, y: pageDrawIndex * Int(viewHeight)), animated: false)
        let pageSize = CGSize(width: scrollView.frame.width, height: viewHeight)
        let splitRect = CGRect(origin: CGPoint(x: 0, y: CGFloat(pageDrawIndex) * viewHeight), size: pageSize)
        var resultImage = resultImage
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            UIGraphicsBeginImageContextWithOptions(pageSize, true, UIDevice.deviceScale)
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
