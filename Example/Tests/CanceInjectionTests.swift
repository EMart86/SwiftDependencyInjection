//
//  InjectionTests.swift
//  SwiftDependencyInjection
//
//  Created by Martin Eberl on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import SwiftDependencyInjection

class CancelInjectionTests: XCTestCase, Injectable {
    var injector: Injector?
    var expectation: XCTestExpectation?
    var holder: InjectionHolder?
    
    override func setUp() {
        super.setUp()
        injector = Injector.shared
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        holder?.cancel()
        super.tearDown()
    }
    
    func testInjection() {
        expectation = expectation(description: "did find Provideable")
        expectation?.isInverted = true
        holder = injector?.inject(self)
            .with(StringProvidable.self)
        holder?.cancel()
        TestModule().provide()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func inject<T>(inject: T) {
        if let inject = inject as? StringProvidable {
            expectation?.fulfill()
        }
    }
    
}
