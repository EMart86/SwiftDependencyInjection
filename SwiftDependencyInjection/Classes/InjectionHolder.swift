import Foundation

public protocol InjectionHolderDelegate: class {
    func didStore(holder: InjectionHolder)
    func didFinishInjecting(holder: InjectionHolder)
    func didUpdate<T>(module: Module, with type: T.Type)
}

public protocol InjectionHolder: class, InjectionHolderDelegate {
    var delegate: InjectionHolderDelegate? { get set }
    var injectable: Injectable { get }
    
    func storeForLaterInjection(holder: InjectionHolder)
    func inject(_ module: Module)
    func cancel()
    
    @discardableResult func with<T>(_ type: T.Type) -> InjectionHolder
}

public extension InjectionHolder {
    @discardableResult func with<T>(_ type: T.Type) -> InjectionHolder {
        if let module = Injector.shared.module(for: T.self) {
            doInject(module)
        }
        else {
            let holder = DefaultInjectionHolder<T>(injectable: injectable)
            holder.delegate = self
            storeForLaterInjection(holder: holder)
        }
        return self
    }
    
    public func cancel() {
        delegate?.didFinishInjecting(holder: self)
    }
    
    private func doInject(_ module: Module) {
        injectable.inject(inject: module)
        delegate?.didFinishInjecting(holder: self)
    }
}


public final class ForwardInjectionHolder: InjectionHolder {
    public weak var delegate: InjectionHolderDelegate?
    public let  injectable: Injectable
    public private(set) var modules: [Module]?
    public private(set) var holders: [InjectionHolder]?
    
    public init(injectable: Injectable, modules: [Module]) {
        self.injectable = injectable
        self.modules = modules
    }
    
    public func storeForLaterInjection(holder: InjectionHolder) {
        add(holder: holder)
    }
    
    public func didStore(holder: InjectionHolder) {
        add(holder: holder)
    }
    
    public func didFinishInjecting(holder: InjectionHolder) {
        remove(holder: holder)
        if holders?.isEmpty ?? false {
            delegate?.didFinishInjecting(holder: self)
        }
    }
    
    public func didUpdate<T>(module: Module, with type: T.Type) {
        holders?.forEach({ $0.didUpdate(module: module, with: T.self) })
    }
    
    public func inject(_ module: Module) {
        holders?.forEach({ $0.inject(module) })
    }
    
    //MARK: - Private
    
    private func index(of module: Module) -> Int? {
        return modules?.index(where: { $0 === module })
    }
    
    private func notifyDidStore(holder: InjectionHolder) {
        delegate?.didStore(holder: self)
    }
    
    private func index(of holder: InjectionHolder) -> Int? {
        return holders?.index(where: { $0 === holder })
    }
    
    private func add(holder: InjectionHolder) {
        guard index(of: holder) == nil else {
            return
        }
        if holders == nil {
            holders = [InjectionHolder]()
        }
        holders?.append(holder)
        notifyDidStore(holder: holder)
    }
    
    private func remove(holder: InjectionHolder) {
        guard let index = index(of: holder) else {
            return
        }
        holders?.remove(at: index)
    }
}

public final class DefaultInjectionHolder<H>: InjectionHolder {
    public weak var delegate: InjectionHolderDelegate?
    public let  injectable: Injectable
    public private(set) var modules: [Module]?
    
    public init(injectable: Injectable, modules: [Module]? = nil) {
        self.injectable = injectable
        self.modules = modules
    }
    
    public func storeForLaterInjection(holder: InjectionHolder) {}
    
    @discardableResult public func with<T>(_ type: T.Type) -> InjectionHolder {
        if let module = Injector.shared.module(for: T.self) {
            inject(module)
        }
        return self
    }
    
    public func didStore(holder: InjectionHolder) { }
    
    public func didFinishInjecting(holder: InjectionHolder) { }
    
    public func inject(_ module: Module) {
        if module is H {
            injectable.inject(inject: module)
            delegate?.didFinishInjecting(holder: self)
        }
    }
    
    public func didUpdate<T>(module: Module, with type: T.Type) {}
}
