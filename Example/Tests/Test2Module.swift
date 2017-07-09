//
//  TestModule.swift
//  SwiftDependencyInjection
//
//  Created by Martin Eberl on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SwiftDependencyInjection

protocol String2Providable {
    var test: String { get }
}

final class Test2Module: Module, String2Providable {
    weak var delegate: ModuleDelegate?
    var providable: StringProvidable?
    static let defaultText = "Provideable could'nt be inferred"
    
    init() {
        requiresFor(type: String2Providable.self)
            .this(type: StringProvidable.self)
        
    }
    
    var test: String {
        Injector.shared.inject(self)
            .with(type: StringProvidable.self)
        if let providable = providable {
            return "\(providable.test) - 2"
        }
        return Test2Module.defaultText
    }
    
    func inject<T>(inject: T) {
        if let inject = inject as? StringProvidable {
            providable = inject
        }
    }
}
