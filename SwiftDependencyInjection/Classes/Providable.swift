//
//  Provideable.swift
//  Costplanner
//
//  Created by Martin Eberl on 05.07.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

public protocol Providable {
    func provide<T>(type: T)
}
