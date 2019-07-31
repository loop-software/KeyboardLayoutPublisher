//
//  KeyboardPublisher.swift
//
//
//  Created by Jacob Christie on 2019-07-31.
//  Copyright © 2019 Loop Software. All rights reserved.

import Combine
import Foundation

/// A publisher that emits events when the software keyboard's layout will change
public struct KeyboardLayoutPublisher: Publisher {
    public typealias Output = KeyboardLayout
    public typealias Failure = Never

    /// The keyboard layout events the publisher will publish
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
