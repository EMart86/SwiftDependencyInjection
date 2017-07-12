//
//  Injector.swift
//  Costplanner
//
//  Created by Martin Eberl on 01.07.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

open class Injector: InjectionHolderDelegate, ModuleDelegate {
    
    private static var instance = Injector()
    public var modules = [Module]()
    private var holders: [InjectionHolder]?
    private var dependencies: [Dependency]?
    
    public class var shared: Injector {
        return instance
    }
    
    private init() {}
    
    public func inject(_ this: Injectable) -> InjectionHolder {
        let holder = ForwardInjectionHolder(injectable: this, modules: modules)
        holder.delegate = self
        return holder
    }
    
    public func add(_ module: Module) {
        module.delegate = self
        modules.append(module)
        
        dependencies?.forEach({ $0.tryToResolve() })
        
        if let dependencies = dependencies {
            if let dependency = dependencies.first(where: { $0.module === module }),
                dependency.isResolved {
                holders?.forEach({ $0.inject(module) })
            }
        } else {
            holders?.forEach({ $0.inject(module) })
        }
    }
    
    public func add(_ dependency: Dependency) {
        if dependencies == nil {
            dependencies = [Dependency]()
        }
        var aDependency = dependency
        aDependency.delegate = self
        dependencies?.append(dependency)
    }
    
    public func didStore(holder: InjectionHolder) {
        add(holder: holder)
    }
    
    public func didFinishInjecting(holder: InjectionHolder) {
        remove(holder: holder)
        //TODO: try to search for the next injectable module or try to resolve the dependencies
    }
    
    public func didUpdate<T>(module: Module, with type: T.Type) { }
    
    public func module<T>(_ module: Module, didProvide type: T.Type) {
        holders?.forEach({ $0.didUpdate(module: module, with: T.self) })
    }
    
    public func module<T>(for type: T.Type) -> Module? {
        guard let dependencies = dependencies else {
            return nil
        }
        let filteredDependencies = dependencies.filter({ $0.conforms(to: T.self) })
        if filteredDependencies.isEmpty {
            return modules.filter({ $0 is T }).first
        }
        return filteredDependencies.filter({ $0.isResolved }).first?.module
    }
    
    
    
    //MARK: - Private
    
    private func index(of holder: InjectionHolder) -> Int? {
        return holders?.index(where: {
            return $0 === holder
        })
    }
    
    private func add(holder: InjectionHolder) {
        guard index(of: holder) == nil else {
            return
        }
        if holders == nil {
            holders = [InjectionHolder]()
        }
        holders?.append(holder)
    }
    
    private func remove(holder: InjectionHolder) {
        guard let index = index(of: holder) else {
            return
        }
        holders?.remove(at: index)
    }
    
    fileprivate func provide<T>(_ module: Module, with type: T.Type) {
        dependencies?.forEach({
            if $0.requires(T.self) {
                $0.tryToResolve()
            }})
        holders?.forEach({ $0.inject(module) })
    }
}

extension Injector: DependencyDelegate {
    public func didResolve<T>(dependency: Dependency, canProvide type: T.Type) {
        provide(dependency.module, with: T.self)
    }
}

@discardableResult public func +(left: Injector, right: Module) -> Injector {
    left.add(right)
    return left
}
