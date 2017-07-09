//
//  Injectable.swift
//  Costplanner
//
//  Created by Martin Eberl on 03.07.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation

public protocol Injectable: class {
    func inject<T>(inject: T)
}
