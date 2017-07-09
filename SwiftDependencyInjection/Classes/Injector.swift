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
    private var modules = [Module]()
    private var holders: [InjectionHolder]?
    
    public class var shared: Injector {
        return instance
    }
    
    private init() {}
    
    public func inject(_ this: Injectable) -> InjectionHolder {
        let holder = ForwardInjectionHolder(injectable: this, modules: modules)
        holder.delegate = self
        return holder
    }
    
    public func add(module: Module) {
        module.delegate = self
        modules.append(module)
        
        holders?.forEach({ $0.add(module: module) })
    }
    
    public func didStore(holder: InjectionHolder) {
        add(holder: holder)
    }
    
    public func didFinishInjecting(holder: InjectionHolder) {
        remove(holder: holder)
    }
    
    public func didUpdate<T>(module: Module, with type: T.Type) { }
    
    public func module<T>(_ module: Module, didProvide type: T.Type) {
        holders?.forEach({ $0.didUpdate(module: module, with: T.self) })
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
}

@discardableResult public func +(left: Injector, right: Module) -> Injector {
    left.add(module: right)
    return left
}
