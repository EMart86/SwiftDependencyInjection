//
//  InjectionTests.swift
//  SwiftDependencyInjection
//
//  Created by Martin Eberl on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import SwiftDependencyInjection

class NewObjectCreateTests: XCTestCase, Injectable {
    var injector: Injector?
    var expectation: XCTestExpectation?
    var holder: InjectionHolder?
    
    override func setUp() {
        super.setUp()
        TestModule().provide()
        
        injector = Injector.shared
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        holder?.cancel()
        super.tearDown()
    }
    
    func testInjection() {
        expectation = expectation(description: "did find Provideable")
        holder = injector?.inject(self)
            .with(FooProvidable.self)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func inject<T>(inject: T) {
        if let inject = inject as? FooProvidable {
            let foo = inject.foo
            XCTAssert(foo !== inject.foo)
            expectation?.fulfill()
        }
    }
    
}
