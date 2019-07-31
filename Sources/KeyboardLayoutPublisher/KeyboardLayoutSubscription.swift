//
//  KeyboardLayoutSubscription.swift
//  
//
//  Created by Jacob Christie on 2019-07-31.
//  Copyright © 2019 Loop Software. All rights reserved.

import Combine
import Foundation

final class KeyboardLayoutSubscription<
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
