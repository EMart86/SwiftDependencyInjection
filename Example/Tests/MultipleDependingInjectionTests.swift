//
//  InjectionTests.swift
//  SwiftDependencyInjection
//
//  Created by Martin Eberl on 09.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import SwiftDependencyInjection

class MultipleDependingInjectionTests: XCTestCase, Injectable {
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
        holder = injector?.inject(self)
            .with(String3Providable.self)
        Test3Module().provide()
        Test2Module().provide()
        TestModule().provide()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func inject<T>(inject: T) {
        if let inject = inject as? String3Providable {
            let text = inject.test
            XCTAssert(text.contains(TestModule.defaultText)
                && text.contains(Test2Module.correctText))
            expectation?.fulfill()
        }
    }
    
}
