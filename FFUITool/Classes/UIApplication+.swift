//
//  UIApplication+.swift
//  FFUITool
//
//  Created by cofey on 2022/9/2.
//

import Foundation

extension UIApplication {
    /// EZSE: Run a block in background after app resigns activity
    public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }

    /// EZSE: Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    @objc public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
//        if let alert = base as? UIAlertController {
//            if let presenting = alert.presentingViewController {
//                return presenting
//            }
//        }
        return base
    }
    
//    public class func topNavi(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//        if let nav = base as? UINavigationController {
//            return nav
//        }
//        if let tab = base as? UITabBarController {
//            if let selected = tab.selectedViewController {
//                return topViewController(selected)
//            }
//        }
//        if let presented = base?.presentedViewController {
//            return topViewController(presented)
//        }
//        return base
//    }
    
    public class func openApplicationInSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString), shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                shared.open(url, options: [:], completionHandler: { (bool) in })
            } else {
                // Fallback on earlier versions
            }
        } else {

        }
    }
    
    public class func hideStatusBar(with animation: UIStatusBarAnimation = .fade) {
        UIApplication.shared.setStatusBarHidden(true, with: animation)
    }
    
    public class func showStatusBar(with animation: UIStatusBarAnimation = .fade) {
        UIApplication.shared.setStatusBarHidden(false, with: animation)
    }
    
    @objc public static var ifInstalledFacebook: Bool {
        let urlString = "fb://"
        if let url = URL(string: urlString) {
            return shared.canOpenURL(url)
        } else {
            return false
        }
    }

    @objc public static var ifInstalledTwitter: Bool {
        let urlString = "twitter://"
        if let url = URL(string: urlString) {
            return shared.canOpenURL(url)
        } else {
            return false
        }
    }
    
    @objc public static var ifInstalledInstagram: Bool {
        let urlString = "instagram://"
        if let url = URL(string: urlString) {
            return shared.canOpenURL(url)
        } else {
            return false
        }
    }
    
    @objc public static var ifInstalledLine: Bool {
        let urlString = "line://msg"
        if let url = URL(string: urlString) {
            return shared.canOpenURL(url)
        } else {
            return false
        }
    }

    @objc public static var AppRoot: UIViewController? {
        set {
            shared.keyWindow?.rootViewController = newValue
        }
        get {
            if let root = shared.keyWindow?.rootViewController {
                return root
            } else {
                return nil
            }
        }
    }
    
    @objc public static var AppTop: UIViewController? {
        if let top = topViewController() {
            return top
        } else {
            return nil
        }
    }
    
    @objc public static var AppWindow: UIWindow? {
        if let window = shared.keyWindow {
            return window
        } else {
            return nil
        }
    }
}
