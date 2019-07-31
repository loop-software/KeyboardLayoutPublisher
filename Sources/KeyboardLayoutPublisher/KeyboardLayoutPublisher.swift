//
//  KeyboardPublisher.swift
//  ATP
//
//  Created by Jacob Christie on 2019-07-29.
//  Copyright © 2019 Loop Software. All rights reserved.
//

import Combine
import Foundation
import UIKit.UIView

public struct KeyboardLayout {
    public let beginFrame: CGRect
    public let endFrame: CGRect
    public let animationCurve: UIView.AnimationCurve
    public let animationDuration: TimeInterval
    public let isLocal: Bool

    fileprivate init(_ notification: Notification) {
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

extension KeyboardLayout {
    public struct Event: RawRepresentable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        private init(_ notif: Notification.Name) {
            self.init(rawValue: notif.rawValue)
        }

        public static let willHide =
            Event(UIResponder.keyboardWillHideNotification)
        public static let didHide =
            Event(UIResponder.keyboardDidHideNotification)

        public static let willShow =
            Event(UIResponder.keyboardWillShowNotification)
        public static let didShow =
            Event(UIResponder.keyboardDidShowNotification)

        public static let willChangeFrame =
            Event(UIResponder.keyboardWillChangeFrameNotification)
        public static let didChangeFrame =
            Event(UIResponder.keyboardDidChangeFrameNotification)
    }
}

public struct KeyboardLayoutPublisher: Publisher {
    public typealias Output = KeyboardLayout
    public typealias Failure = Never

    public let events: [KeyboardLayout.Event]

    public init(event: KeyboardLayout.Event) {
        self.init(events: [event])
    }

    public init(events: [KeyboardLayout.Event]) {
        self.events = events
    }

    public func receive<S>(subscriber: S)
        where S : Subscriber,
        KeyboardLayoutPublisher.Failure == S.Failure,
        KeyboardLayoutPublisher.Output == S.Input
    {
        let subscription = KeyboardLayoutSubscription(
            subscriber: subscriber,
            events: events
        )
        subscriber.receive(subscription: subscription)
    }
}

private final class KeyboardLayoutSubscription<
    SubscriberType: Subscriber
>: Subscription where SubscriberType.Input == KeyboardLayout {
    private var subscriber: SubscriberType?
    private var tokens: [NSObjectProtocol] = []

    init(subscriber: SubscriberType, events: [KeyboardLayout.Event]) {
        self.subscriber = subscriber
        self.tokens = events.map {
            NotificationCenter.default.addObserver(
                forName: Notification.Name($0.rawValue),
                object: nil,
                queue: .main,
                using: notificationHandler(_:)
            )
        }
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        tokens.forEach { NotificationCenter.default.removeObserver($0) }
        subscriber = nil
    }

    private func notificationHandler(_ notification: Notification) {
        let notification = KeyboardLayout(notification)
        _ = subscriber?.receive(notification)
    }
}
