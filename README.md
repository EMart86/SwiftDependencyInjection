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

## Usage

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


2) Requesting the implementations of the protocol (e.g. in your ViewController or in any other viewmodels):

```
Injector.shared.inject(self)
.with(FooProvider.self)
```

This helps the injector to provide you the required dependencies. Add .with(...Provider.self) to request more dependencies.

3) Implement the Injectable protocol:


```swift
func inject(inject: Any) {
    if let inject = inject as? FooProvider {
        foo = inject.foo
    }
}
```

## Module Dependencies

Let's say some of your modules require dependencies from other modules. You than may want the injector to do the hard work and resolve those dependencies. 

Here we have a LectureProvider which provides a Repository of lectures to students.
```swift
import SwiftDependencyInjection

protocol LectureProvidable {
    var repository: LectureRepository { get }
}

final class LectureProviderModule: Module, LectureProvidable {
    weak var delegate: ModuleDelegate?

    //lazy makes a var to a singleton
    lazy var repository: LectureRepository = {
        return LectureRepository()
    }()
}
```

Now based on the numbers of our students, we want to get a room or in case the auditorium  is still too small, we need to hold the lecture open air
```swift


enum Room: Int {
    case lectureRoom = 20
    case lectureHall = 50
    case auditorium = 300

    statuc func for(_ numberOfStudents: Int) -> Room? {
        if numberOfStudents <= Room.lectureRoom.rawValue {
            return .lectureRoom
        }
        if numberOfStudents <= Room.lectureHall.rawValue {
            return .lectureHall
        }
        if numberOfStudents <= Room.lectureHall.rawValue {
            return .auditorium
        }
        return nil
    }

    func holdLecture(_ lector: Lector) {} 
}

import SwiftDependencyInjection

protocol RoomProvidable {
    func room(for lectureId: String) -> Room?
}

final class RoomProviderModule: Module, RoomProvidable {
    weak var delegate: ModuleDelegate?
    weak var lectureRepository: LectureRepository?

    init() {
        requires(for: RoomProvidable)?
            .this(LectureProvidable.self)
          //.this(... .self) we would add here more dependencies if we needed to
    }

    func room(for lectureId: Int) -> Room? {
        guard let lecture = lectureRepository.lectures(with: lectureId) else {
            return nil
        }
        return Room.for(lecture.subscibedStudents)
    }

    func inject(inject: Any) {
        if let inject = inject as? LectureProvidable {
            lectureRepository = inject.repository
        }
    }
}
```

Now we need to register the Modules

```swift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

        RoomProviderModule().provide()
        LectureProviderModule().provide()
        
        return true
    }
    ...
}
```

And finally we want our lector to provide a lecture, on which students may subscribe and a room should be selected automatically based on the number of students

```swift
final class Lector {
    var roomProvidable: RoomProvidable?
    var lectureProvidable: LectureProvidable?

    init() {
        Injector.shared.inject(self)
            .with(RoomProvidable.self)
            .with(LectureProvidable.self)
    }

    func inject(inject: Any) {
        if let inject = inject as? RoomProvidable {
            roomProvidable = inject
        }
        if let inject = inject as? LectureProvidable {
            lectureProvidable = inject
        }
    }

    func provideLecture(lectureId: Int) {
        guard let lectureProvidable = lectureProvidable else {
            return
        }
        lectureProvideable.provide(Lecture(id: lectureId, lector: this, Date(2017, 12, 03), estimatedHours: 2))
    }

    func holdLecture(lectureId: Int) {
        guard let room = roomProvidable.room(for: lectureId) else {
            //hold lecture outside
            return
        }
        room.holdLecture(this)
    }
}
```

I'd love to here, if you'd need any further samples or have improovement proposals
