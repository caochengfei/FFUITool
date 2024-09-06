//
//  TapticEngine.swift
//  FFUITool
//
//  Created by cofey on 2022/9/2.
//

import Foundation
import AudioToolbox
import UIKit

open class TapticEngine: NSObject {
    
    @available(iOS 10.0, *)
    fileprivate static var notificationGenerator: UINotificationFeedbackGenerator = {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        return generator
    }()
    
    @available(iOS 10.0, *)
    fileprivate static var selectionGenerator: UISelectionFeedbackGenerator? = {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            return generator
        } else {
            return nil
        }
    }()
    
    @objc public static func lightBoom() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
        }
    }
    
    public static func mediumBoom() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
        }
    }
    
    public static func heavyBoom() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc public static func successBoom() {
        if #available(iOS 10.0, *) {
            notificationGenerator.notificationOccurred(.success)
            notificationGenerator.prepare()
        } else {
            // Fallback on earlier versions
        }
    }
    
    public static func warningBoom() {
        if #available(iOS 10.0, *) {
            notificationGenerator.notificationOccurred(.warning)
            notificationGenerator.prepare()
        } else {
            // Fallback on earlier versions
        }
    }
    
    public static func errorBoom() {
        if #available(iOS 10.0, *) {
            notificationGenerator.notificationOccurred(.error)
            notificationGenerator.prepare()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc public static func selectionBoom() {
        if #available(iOS 10.0, *) {
            selectionGenerator?.selectionChanged()
            selectionGenerator?.prepare()
        } else {
            // Fallback on earlier versions
        }
    }

    
    public static func peekBoom() {
        AudioServicesPlaySystemSound(1519)
    }
    
    public static func popBoom() {
        AudioServicesPlaySystemSound(1520)
    }
    
    public static func feedBackBoom() {
        AudioServicesPlaySystemSound(1521)
    }
}
