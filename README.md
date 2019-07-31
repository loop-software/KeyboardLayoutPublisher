# KeyboardLayoutPublisher

A Combine Publisher to notify of major keyboard layout changes (outlined in [UIResponder](https://developer.apple.com/documentation/uikit/uiresponder) under Type Properties)

## Usage
To subscibe to layout changes initialize the publisher with the desired layout events.
```
let keyboardWillChange = SoftwareKeyboardLayoutPublisher(
    events: [.willShow, .willHide]
)
```

Basic keyboard avoidance can be implemented in a view controller with `UIScrollView`
```
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
```
_ = keyboardWillChange
    .subscribe(on: RunLoop.main)
    .sink(receiveValue: adjustView(forKeyboardLayout:))
```
