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
    var fullfillmentDescriptors: [FullfillmentDescription]?
    static let defaultText = "Provideable could'nt be inferred"
    static let correctText = TestModule.defaultText + " - 2"
    
    init() {
        requires(for: String2Providable.self)?
            .this(StringProvidable.self)
    }
    
    var test: String {
        if let providable = providable {
            return "\(providable.test) - 2"
        }
        return Test2Module.defaultText
    }
    
    func inject(inject: Any) {
        if let inject = inject as? StringProvidable {
            providable = inject
        }
    }
}
