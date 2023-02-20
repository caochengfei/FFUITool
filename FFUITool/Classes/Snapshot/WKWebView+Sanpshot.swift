//
//  WKWebView+Sanpshot.swift
//  FBSnapshotTestCase
//
//  Created by cofey on 2023/1/31.
//

import Foundation
import WebKit

extension WKWebView {
    
    /// WKWebView 长截图,对于高度有限制,高度太高会导致内存占用过多 webview进程被杀死
    /// - Parameters:
    ///   - webView: webView
    ///   - completion: UIImage?
    public func ff_takeSnapshotImage(webView: WKWebView, completion: @escaping (UIImage?) -> ()) {
        guard let snapShotView = webView.snapshotView(afterScreenUpdates: true) else {
            completion(nil)
            return
        }
        snapShotView.frame = CGRect(x: webView.frame.origin.x, y: webView.frame.origin.y, width: snapShotView.frame.size.width, height: snapShotView.frame.size.height)
        webView.superview?.addSubview(snapShotView)

        // save the original size to restore
        let originalFrame = webView.frame
        let originalConstraints = webView.constraints
        let originalScrollViewOffset = webView.scrollView.contentOffset

        let newSize = webView.scrollView.contentSize

        var scale = UIScreen.main.scale
        if newSize.height / webView.bounds.size.height > 10 {
            scale = webView.bounds.size.height * 10 / newSize.height * scale
        }
        // remove any constraints for the web view, and set the size
        // to be size of the content size (will be restored later)
        webView.removeConstraints(originalConstraints)
        webView.translatesAutoresizingMaskIntoConstraints = true
        webView.frame = CGRect(origin: webView.frame.origin, size: CGSize(width: newSize.width, height: newSize.height))
        webView.scrollView.contentOffset = .zero

        // wait for a while for the webview to render in the newly set frame
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           defer {
               UIGraphicsEndImageContext()
           }

           UIGraphicsBeginImageContextWithOptions(newSize, true, scale)
           if let context = UIGraphicsGetCurrentContext() {
               // render the scroll view's layer
               context.setRenderingIntent(CGColorRenderingIntent.defaultIntent)
               context.interpolationQuality = .low
               webView.scrollView.layer.render(in: context)
               let image = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()

               // restore the original state
               webView.clearsContextBeforeDrawing = true
               webView.frame = originalFrame
               webView.translatesAutoresizingMaskIntoConstraints = false
               webView.addConstraints(originalConstraints)
               webView.scrollView.contentOffset = originalScrollViewOffset

               if let image = image {
                   completion(image)
               } else {
                   completion(nil)
               }
               DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                   snapShotView.removeFromSuperview()
               }
           }
        }
    }
    
    
    
    /// WKWebView 长截图,采用滚动offSet的形式, 单张图片拼接,解决了position:flexd重叠问题
    /// - Parameters:
    ///   - webView: WKWebView
    ///   - captureComplated: uiimage?
    public func ff_takeSnapshotWebViewScroll(webView: WKWebView, progressHandle: ((_ progress: CGFloat)->())? = nil, captureComplated: @escaping (( _ image: UIImage?)->())) {
        guard let snapShotView = webView.snapshotView(afterScreenUpdates: true) else {
            captureComplated(nil)
            return
        }
        snapShotView.frame = CGRect(x: webView.frame.origin.x, y: webView.frame.origin.y, width: snapShotView.frame.size.width, height: snapShotView.frame.size.height)
        webView.superview?.addSubview(snapShotView)
        
        let scrollOffset = webView.scrollView.contentOffset
        
        let maxIndex = floor(webView.scrollView.contentSize.height / webView.bounds.height)
                
        var scale: CGFloat = 1.0
        let contentMemorySize = webView.scrollView.contentSize.width * webView.scrollView.contentSize.height * CGFloat(UIScreen.main.scale) * 4
        let maxMemorySize: CGFloat = 80 * 1024 * 1024 / UIScreen.main.scale
        if contentMemorySize > maxMemorySize {
            scale = maxMemorySize / contentMemorySize
        }
        webView.scrollView.setContentOffset(.zero, animated: false)
        
        var resultImage: UIImage?
        self.contentScroll(webView: webView, pageDrawIndex: 0, maxIndex: Int(maxIndex), scale: scale, resultImage: &resultImage, progressHandle: progressHandle) { image in
            webView.scrollView.setContentOffset(scrollOffset, animated: false)
            captureComplated(image)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                snapShotView.removeFromSuperview()
            }
        }
        
    }
    
    private func contentScroll(webView: WKWebView, pageDrawIndex: Int, maxIndex: Int, scale: CGFloat, resultImage: inout UIImage?,progressHandle: ((_ progress: CGFloat)->())? = nil, drawCallback: @escaping (UIImage?)->()) {
        webView.scrollView.setContentOffset(CGPoint(x: 0, y: pageDrawIndex * Int(webView.frame.size.height)), animated: false)
        let pageSize = CGSize(width: webView.frame.width, height: webView.frame.height)
        let splitRect = CGRect(origin: CGPoint(x: 0, y: CGFloat(pageDrawIndex) * webView.frame.size.height), size: pageSize)
        var resultImage = resultImage
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            UIGraphicsBeginImageContextWithOptions(pageSize, true, UIScreen.main.scale)
            webView.scrollView.drawHierarchy(in: CGRect(origin: .zero, size: pageSize), afterScreenUpdates: false)
            let image = UIGraphicsGetImageFromCurrentImageContext()?.resized(with: pageSize.width * scale)
            UIGraphicsEndImageContext()
            if let image = image {
                if resultImage == nil {
                    resultImage = image
                    self.hiddenFlexdJavascript(webView: webView)
                } else {
                    if pageDrawIndex >= maxIndex {
                        let scaleH = (webView.scrollView.contentSize.height - splitRect.minY) / pageSize.height
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
                self.contentScroll(webView: webView, pageDrawIndex: pageDrawIndex + 1, maxIndex: maxIndex, scale: scale, resultImage: &resultImage, progressHandle: progressHandle,drawCallback: drawCallback)
            } else {
                self.showFlexdJavascript(webView: webView)
                drawCallback(resultImage)
            }
        }
    }
        
    public func hiddenFlexdJavascript(webView: WKWebView) {
        let hiddenFlexdJavascriptString = """
        var divArray = document.querySelectorAll('div');
        var navArray = document.querySelectorAll('nav');
        var asideArray = document.querySelectorAll('aside');
        var flexdDiv = []
        for (let element of divArray) {
            var position = window.getComputedStyle(element,null).position;
            if (position == 'fixed') {
                element.style.cssText='visibility:hidden;'
                flexdDiv.push(element);
            }
            if (position == 'sticky') {
                element.style.cssText='visibility:hidden;'
                flexdDiv.push(element);
            }
        }
        for (let element of navArray) {
            var position = window.getComputedStyle(element,null).position;
            if (position == 'fixed') {
                element.style.cssText='visibility:hidden;'
                flexdDiv.push(element);
            }
            if (position == 'sticky') {
                element.style.cssText='visibility:hidden;'
                flexdDiv.push(element);
            }
        }
        for (let element of asideArray) {
            var position = window.getComputedStyle(element,null).position;
            if (position == 'fixed') {
                element.style.cssText='visibility:hidden;'
                flexdDiv.push(element);
            }
            if (position == 'sticky') {
                element.style.cssText='visibility:hidden;'
                flexdDiv.push(element);
            }
        }
        """
        
        webView.evaluateJavaScript(hiddenFlexdJavascriptString) { result, error in
        }
    }
    
    public func showFlexdJavascript(webView: WKWebView) {
        let showFlexdJavascriptString = """
        for (let element of flexdDiv) {
            element.style.cssText='visibility:visible;'
        }
        """
        webView.evaluateJavaScript(showFlexdJavascriptString) { result, error in
        }
    }
}
