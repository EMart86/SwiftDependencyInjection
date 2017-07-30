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
    func canProvide<T>(type: T.Type) -> Bool
    func provide()
    func requires<T>(for type: T.Type) -> FullfillmentDescription?
}

public extension Module {
    public func provide() {
        Injector.shared + self
    }
    
    public func requires<T>(for type: T.Type) -> FullfillmentDescription? {
        guard self is T else {
            return nil
        }
        
        let descriptor = DefaultDependency<T>(self)
        Injector.shared.add(descriptor)
        return descriptor
    }
    
    func canProvide<T>(type: T.Type) -> Bool {
        return self is T
    }
    
    func injectAndNotify<T>(_ module: T) {
        inject(inject: module)
        delegate?.module(self, didProvide: T.self)
    }
    
    func inject(inject: Any) { }
}
