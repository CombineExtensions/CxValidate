# CxValidate
## A µFramework for HTTP Request Validation with Combine

![Build Status](https://github.com/CombineExtensions/CxValidate/workflows/CI/badge.svg) ![Current Version](https://img.shields.io/github/v/tag/CombineExtensions/CxValidate?color=purple&label=Version) ![swift-package-manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-red.svg) ![platforms](https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20watchOS-informational.svg) ![swift-version](https://img.shields.io/badge/Swift-5.1-orange.svg) ![license](https://img.shields.io/badge/License-MIT-c41d3a.svg)

The `validate()` operator checks that a valid `HTTPURLResponse` was returned with a status code in the range of `200...299` and forwards along the `Data` returned from the request.

```swift
let cancellable = URLSession.shared
  .dataTaskPublisher(for: URL(string: "https://someurl.com/"))
  .validate()
  .sink { (response: Data) in
    // Do something with your data
  }
```
