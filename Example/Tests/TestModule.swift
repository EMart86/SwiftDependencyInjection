//
//  TestModule.swift
//  SwiftDependencyInjection
//
//  Created by Martin Eberl on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SwiftDependencyInjection

protocol StringProvidable {
    var test: String { get }
}

protocol SingletonFooProvidable {
    var singletonFoo: Foo { get }
}

protocol FooProvidable {
    var foo: Foo { get }
}

final class TestModule: Module, StringProvidable, SingletonFooProvidable, FooProvidable {
    weak var delegate: ModuleDelegate?
    static let defaultText = "Hello World"
    
    var test: String {
        return TestModule.defaultText
    }
    
    lazy var singletonFoo: Foo = {
       return Foo()
    }()
    
    var foo: Foo {
        return Foo()
    }
}
