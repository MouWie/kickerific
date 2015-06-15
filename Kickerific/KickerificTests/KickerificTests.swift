//
//  BasicTest.swift
//  bFixing
//
//  Created by Ben on 13/05/15.
//  Copyright (c) 2015 mantro.net . All rights reserved.
//

import Foundation
import XCTest

class KickerifficTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func test_Basic () {
        
        let arr1 : [String] = ["Test1"]
        let arr2 : [String] = ["Test2"]
        
        XCTAssert( arr1 != arr2 )
        
        var copy : [String] = arr1
        
        // value comparison
        XCTAssert ( arr1 == copy )
        copy.append("second")
        
        // arrays are value types (like struct), not reference types.
        // they are implicitely cloned when assigning to a different variable
        XCTAssert ( arr1 != copy)
        XCTAssert ( arr1.count == 1)
        XCTAssert (copy.count == 2)
    }
    
    func test_Threading() {
        
        var threadGotLock = false
        var threadIsStarted = false
        var threadWillExit = false
        
        let lock = 0
        objc_sync_enter(lock)
        
        let queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL)
        
        dispatch_async(queue) {
            
            threadIsStarted = true
            objc_sync_enter(lock)
            threadWillExit = true
        }
        
        while !threadIsStarted {
            NSThread.sleepForTimeInterval(0.05)
        }
        
        NSThread.sleepForTimeInterval(0.10)
        XCTAssert(threadWillExit == false)
        
        objc_sync_exit(lock)
        
        while !threadWillExit {
            NSThread.sleepForTimeInterval(0.05)
        }
    }
    
    
    func test_dynamicInstance1() {
        
        // does only work with a "required init" in the base class
        // no need to @objc the classes
        
        let name = NSStringFromClass(BaseChild1.self)
        
        let type : AnyClass = NSClassFromString(name)!
        
        let klass : BasicParent1.Type = type as! BasicParent1.Type
        
        let instance = klass()
        
        XCTAssert(instance is BaseChild1)
    }
    
    func test_dynamicInstance2() {
        
        let factory = BasicFactory<BasicParent1>()
        
        factory.add("child", klass: BaseChild1.self)
        
        let child = factory.create("child")!
        
        print(child.dynamicType)
    }
}

class BasicParent1 {
    func parentMethod() -> String {
        return "parent"
    }
    
    required init() {
        
    }
}

class BaseChild1 : BasicParent1 {
    func childMethod() -> String {
        return "child"
    }
}

class BasicFactory<T:BasicParent1> {
    
    private var hash : Dictionary<String, T.Type> = Dictionary<String,T.Type>()
    
    func add(name:String, klass: T.Type) {
        
        hash[name] = klass
    }
    
    func create(name:String) -> T? {
        
        if let entry = hash[name] {
            
            return entry()
            
        }
        
        return nil
    }
    
}

