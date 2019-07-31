//
//  KeyboardLayout+Event.swift
//  
//
//  Created by Jacob Christie on 2019-07-31.
//  Copyright © 2019 Loop Software. All rights reserved.

import Foundation
import UIKit.UIResponder

extension KeyboardLayout {
    ///
    public struct Event: RawRepresentable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        private init(_ notif: Notification.Name) {
            self.init(rawValue: notif.rawValue)
        }

        /// Posted immediately prior to the dismissal of the keyboard.
        public static let willHide =
            Event(UIResponder.keyboardWillHideNotification)
        /// Posted immediately after the dismissal of the keyboard.
        public static let didHide =
            Event(UIResponder.keyboardDidHideNotification)

        /// Posted immediately prior to the display of the keyboard.
        public static let willShow =
            Event(UIResponder.keyboardWillShowNotification)
        /// Posted immediately after the display of the keyboard.
        public static let didShow =
            Event(UIResponder.keyboardDidShowNotification)

        /// Posted immediately prior to a change in the keyboard’s frame.
        public static let willChangeFrame =
            Event(UIResponder.keyboardWillChangeFrameNotification)
        /// Posted immediately after a change in the keyboard’s frame.
        public static let didChangeFrame =
            Event(UIResponder.keyboardDidChangeFrameNotification)
    }
}
