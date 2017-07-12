//
//  TestModule.swift
//  SwiftDependencyInjection
//
//  Created by Martin Eberl on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SwiftDependencyInjection

protocol String3Providable {
    var test: String { get }
}

final class Test3Module: Module, String3Providable {
    weak var delegate: ModuleDelegate?
    var providable: StringProvidable?
    var providable2: String2Providable?
    static let defaultText = "Provideable could'nt be inferred"
    
    init() {
        requires(for: String3Providable.self)?
            .this(StringProvidable.self)
            .this(String2Providable.self)
    }
    
    var test: String {
        if let providable = providable,
            let providable2 = providable2 {
            return "\(providable.test) \(providable2.test) - 3"
        }
        return Test2Module.defaultText
    }
    
    func inject<T>(inject: T) {
        if let inject = inject as? StringProvidable {
            providable = inject
        }
        if let inject = inject as? String2Providable {
            providable2 = inject
        }
    }
}
