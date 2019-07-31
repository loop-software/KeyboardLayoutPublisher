//
//  KeyboardLayout.swift
//  
//
//  Created by Jacob Christie on 2019-07-31.
//  Copyright © 2019 Loop Software. All rights reserved.

import Foundation
import UIKit.UIResponder

/// Encapsualtes the layout changes for the keyboard
public struct KeyboardLayout {
    /// The starting frame rectangle of the keyboard in screen coordinates.
    /// The frame rectangle reflects the current orientation of the device.
    public let beginFrame: CGRect

    /// The ending frame rectangle of the keyboard in screen coordinates.
    /// The frame rectangle reflects the current orientation of the device.
    public let endFrame: CGRect

    /// How the keyboard will be animated onto or off the screen
    /// - Note: As of iOS 7, the keyboard animates using a private `AnimationCurve`
    public let animationCurve: UIView.AnimationCurve

    /// The duration of the animation
    public let animationDuration: TimeInterval

    /// A Boolean that identifies whether the keyboard belongs to the current app.
    /// With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears.
    /// The value of this key is `true` for the app that caused the keyboard to appear and `false` for any other apps.
    public let isLocal: Bool

    init(_ notification: Notification) {
        let userInfo = notification.userInfo!
        self.beginFrame =
            userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect

        self.endFrame =
            userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect

        let curve =
            userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        self.animationCurve = UIView.AnimationCurve(rawValue: curve.intValue)!

        self.animationDuration =
            userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
            as! TimeInterval

        self.isLocal = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as! Bool
    }
}
