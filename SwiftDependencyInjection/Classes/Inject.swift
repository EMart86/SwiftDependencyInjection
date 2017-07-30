//
//  Inject.swift
//  Pods
//
//  Created by Martin Eberl on 30.07.17.
//
//

import Foundation

public final class Inject<T>: Injectable {
    public private(set) var value: T? {
        didSet {
            if let didSet = didSet {
                didSet(value)
            }
        }
    }
    private var didSet: Callback?
    public typealias Callback = (T?) -> Void
    
    public init(_ didSet: Callback? = nil) {
        self.didSet = didSet
        
        Injector.shared.inject(self)
            .with(T.self)
        
    }
    
    //MARK: - Injectable Implementation
    
    public func inject(inject: Any) {
        if let inject = inject as? T {
            value = inject
        }
    }
}
