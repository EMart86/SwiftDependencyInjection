//
//  FullfillmentDescription.swift
//  Pods
//
//  Created by Martin Eberl on 09.07.17.
//
//

import Foundation

public protocol FullfillmentDescription {
    @discardableResult func this<T>(_ type: T.Type) -> FullfillmentDescription
}

public protocol DependencyDelegate: class {
    func didResolve<T>(dependency: Dependency, canProvide type: T.Type)
}

public protocol Dependency: FullfillmentDescription {
    var isResolved: Bool { get }
    var parameters: [FullfillmentParameter]? { get }
    var module: Module { get }
    var delegate: DependencyDelegate? { get set }
    
    @discardableResult func tryToResolve() -> Bool
    func didProvide<T>(type: T.Type)
    func conforms<T>(to type: T.Type) -> Bool
    func requires<T>(_ type: T.Type) -> Bool
}

extension Dependency {
    public var isResolved: Bool {
        return parameters?.isEmpty ?? true
    }
    
    public func conforms<T>(to type: T.Type) -> Bool {
        return module is T
    }
}

public protocol FullfillmentParameter: class {
    var moduleForFullfillment: Module? { get }
    func requires<T>(_ type: T.Type) -> Bool
}

final public class DefaultFullfillmentParameter<H>: FullfillmentParameter {
    public var moduleForFullfillment: Module? {
        return Injector.shared.module(for: H.self)
    }
    
    public func requires<T>(_ type: T.Type) -> Bool {
        return H.self == T.self
    }
}

final public class DefaultDependency<H>: Dependency {
    private(set) public var parameters: [FullfillmentParameter]?
    private(set) public var module: Module
    public weak var delegate: DependencyDelegate?
    
    init(_ module: Module) {
        self.module = module
    }
    
    public func didProvide<T>(type: T.Type) {
        tryToResolve()
    }
    
    @discardableResult public func this<T>(_ type: T.Type) -> FullfillmentDescription {
        if parameters == nil {
            parameters = [FullfillmentParameter]()
        }
        
        let parameter = DefaultFullfillmentParameter<T>()
        if shouldAdd(parameter) {
            parameters?.append(parameter)
        }
        return self
    }
    
    @discardableResult public func tryToResolve() -> Bool {
        guard let parameters = parameters else {
            return true
        }
        
        var fullfilledParameters = [FullfillmentParameter]()
        for parameter in parameters {
            if let moduleForFullfillment = parameter.moduleForFullfillment {
                module.injectAndNotify(moduleForFullfillment)
                fullfilledParameters.append(parameter)
            }
        }
        for parameter in fullfilledParameters {
            remove(parameter)
        }
        if isResolved {
            delegate?.didResolve(dependency: self, canProvide: H.self)
            return true
        }
        return false
    }
    
    public func requires<T>(_ type: T.Type) -> Bool {
        return parameters?.first(where: { $0.requires(T.self) }) != nil
    }
    
    private func remove(_ parameter: FullfillmentParameter) {
        guard let index = parameters?.index(where: { return $0 === parameter } ) else {
            return
        }
        parameters?.remove(at: index)
    }
    
    private func shouldAdd(_ parameter: FullfillmentParameter) -> Bool {
        guard let moduleForFullfillment = parameter.moduleForFullfillment else {
            return true
        }
        
        module.inject(inject: moduleForFullfillment)
        return false
    }
}
