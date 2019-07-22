# Imbue

Wide color picker made using SwiftUI & Combine


## Model

### `ColorValue`

#### `.RGB` struct

Holds red, green, and blue values using the `CGFloat` type.

#### `.Lab` struct

Holds lightness, green-to-red, and blue-to-yellow values using the `CGFloat` type. These values are designed to map closely to how our eyes responds to light — to [“mimic the nonlinear response of the eye”](https://en.wikipedia.org/wiki/CIELAB_color_space).

#### `.sRGB(RGB)` case

The colorspace used by the web, many phones, tablets, and PCs. In other words, it is common-denominator with wide support.

#### `.labD50(Lab)` case

The colorspace used by Photoshop and Affinity Photo. Supports wide color (aka HDR).


## ViewModel

### `AdjustableColorInstance`

Conforming to SwiftUI’s `BindableObject` protocol, this holds the source of truth for the app.

It has a `.State` struct to hold the actual values. This makes notifying the `willChange` publisher easily, simply by using the `willSet` property method.

## View

SwiftUI components which used `ObjectBinding` properties to subscribe to the ViewModel.
