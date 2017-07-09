//
//  FullfillmentDescription.swift
//  Pods
//
//  Created by Martin Eberl on 09.07.17.
//
//

import Foundation

public protocol FullfillmentDescription {
    var isFullfilled: Bool { get }
    @discardableResult func this<T>(type: T.Type) -> FullfillmentDescription
}

public protocol FullfillmentParameter {
}

final public class DefaultFullfillmentParameter<T>: FullfillmentParameter {
    private var protocolType: T.Type
    
    init(type: T.Type) {
        protocolType = type
    }
}

final public class DefaultFullfillmentDescription<H>: FullfillmentDescription {
    private var protocolType: H.Type
    private var parameters: [FullfillmentParameter]?
    
    init(type: H.Type) {
        protocolType = type
    }
    
    @discardableResult public func this<T>(type: T.Type) -> FullfillmentDescription {
        if parameters == nil {
            parameters = [FullfillmentParameter]()
        }
        parameters?.append(DefaultFullfillmentParameter(type: T.self))
        return self
    }
}
