//
//  Module.swift
//  Costplanner
//
//  Created by Martin Eberl on 03.07.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

public protocol ModuleDelegate: class {
    func module<T>(_ module: Module, didProvide type: T.Type)
}

public protocol Module: class, Injectable {
    weak var delegate: ModuleDelegate? { get set }
    var fullfillmentDescriptors: [FullfillmentDescription]? { get }
    func add(fullfillmentDescriptor: FullfillmentDescription)
    func provide()
    func requiresFor<T>(type: T.Type) -> FullfillmentDescription
}

public extension Module {
    func provide() {
        Injector.shared + self
    }
    
    func inject<T>(inject: T) {
        delegate?.module(self, didProvide: T.self)
    }
    
    func requiresFor<T>(type: T.Type) -> FullfillmentDescription {
        let descriptor = DefaultFullfillmentDescription<T>(type: T.self)
        add(fullfillmentDescriptor: descriptor)
        return descriptor
    }
}
