//
//  InjectionTests.swift
//  SwiftDependencyInjection
//
//  Created by Martin Eberl on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import SwiftDependencyInjection

class InjectTest: XCTestCase {
    var injector: Injector?
    var expectation: XCTestExpectation?
    var fooProvider: Inject<StringProvidable>?
    
    override func setUp() {
        super.setUp()
        TestModule().provide()
        
        injector = Injector.shared
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInjection() {
        expectation = expectation(description: "did find Provideable")
        fooProvider = Inject<StringProvidable>({[weak self] _ in
            self?.expectation?.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
