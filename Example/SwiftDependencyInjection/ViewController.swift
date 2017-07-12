//
//  ViewController.swift
//  SwiftDependencyInjection
//
//  Created by eberl_ma@gmx.at on 07/08/2017.
//  Copyright (c) 2017 eberl_ma@gmx.at. All rights reserved.
//

import UIKit
import SwiftDependencyInjection

class ViewController: UIViewController, Injectable {

    private var foo: Foo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Injector.shared.inject(self)
            .with(FooProvider.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        foo?.itWorks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func inject<T>(inject: T) {
        if let inject = inject as? FooProvider {
            foo = inject.foo
        }
    }
}

