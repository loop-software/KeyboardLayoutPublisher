# KeyboardLayoutPublisher

A Combine Publisher to notify of major keyboard layout changes (outlined in [UIResponder](https://developer.apple.com/documentation/uikit/uiresponder) under Type Properties)

## Prerequisites
iOS 13.0+
Xcode 11.0+

## Installation
Include this in your Package.swift dependencies
```swift
.package(url: "https://github.com/loop-software/KeyboardLayoutPublisher", from: "1.0.0")
```

## Usage
To subscibe to layout changes initialize the publisher with the desired layout events.
```swift
let keyboardWillChange = SoftwareKeyboardLayoutPublisher(
    events: [.willShow, .willHide]
)
```

Basic keyboard avoidance can be implemented in a view controller with `UIScrollView`
```swift
_ = keyboardWillChange
    .subscribe(on: RunLoop.main)
    .map { $0.endFrame.height }
    .assign(to: \.contentInset.bottom, on: scrollView)
_ = keyboardWillChange
    .subscribe(on: RunLoop.main)
    .map { $0.endFrame.height }
    .assign(to: \.verticalScrollIndicatorInsets.bottom, on: scrollView)
```

For more advanced keyboard avoidance:
```swift
_ = keyboardWillChange
    .subscribe(on: RunLoop.main)
    .sink(receiveValue: adjustView(forKeyboardLayout:))
```
