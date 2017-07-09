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

final class TestModule: Module, StringProvidable {
    weak var delegate: ModuleDelegate?
    static let defaultText = "Hello World"
    
    var test: String {
        return TestModule.defaultText
    }
}
