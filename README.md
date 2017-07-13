# SwiftDependencyInjection

[![CI Status](http://img.shields.io/travis/EMart86/SwiftDependencyInjection.svg?style=flat)](https://travis-ci.org/eberl_ma@gmx.at/SwiftDependencyInjection)
[![Version](https://img.shields.io/cocoapods/v/SwiftDependencyInjection.svg?style=flat)](http://cocoapods.org/pods/SwiftDependencyInjection)
[![License](https://img.shields.io/cocoapods/l/SwiftDependencyInjection.svg?style=flat)](http://cocoapods.org/pods/SwiftDependencyInjection)
[![Platform](https://img.shields.io/cocoapods/p/SwiftDependencyInjection.svg?style=flat)](http://cocoapods.org/pods/SwiftDependencyInjection)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftDependencyInjection is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftDependencyInjection"
```

## Author

eberl_ma@gmx.at, martin.eberl@styria.com

## License

SwiftDependencyInjection is available under the MIT license. See the LICENSE file for more info.

##Usage

1) Implement a module:

```swift
import SwiftDependencyInjection

protocol FooProvider {
    var foo: Foo { get }
}

final class FooModule: Module, FooProvider {
    weak var delegate: ModuleDelegate?

    lazy var foo: Foo = {
        return Foo()
        }()
}
```

Use a protocol (here FooProvider) to help to communicate and request injection types.


2) Requesting the implementations of the protocol (e.g. in your ViewController or in any other module):

```
Injector.shared.inject(self)
.with(FooProvider.self)
```

This helps the injector to provide you the required dependencies. Add .with(...Provider.self) to request more dependencies.

3) Implement the Injectable protocol:


```swift
func inject<T>(inject: T) {
    if let inject = inject as? FooProvider {
        foo = inject.foo
    }
}
```

## More samples are comming soon

Since we also have implemented some cyclomatic complexity, we'll come back to you soon with an excample of how to use
Stay tuned!
