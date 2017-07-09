//
//  FooModule.swift
//  SwiftDependencyInjection
//
//  Created by Martin Eberl on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
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
