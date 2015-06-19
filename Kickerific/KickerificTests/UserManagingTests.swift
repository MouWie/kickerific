//
//  UserManagingTests.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import UIKit
import XCTest
import Parse

class UserManagingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //Bootstrapper.initializeServices()
        //Bootstrapper.initializeParseFunctions()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_userAuthenticationWorks_works() {
        
        //setup
        let user = "mario"
        let pass = "123"
        let userManager: Optional<AnyObject> = ServiceLocator.sharedInstance.get(UserManagerProtocol)
        
        //currentUser should be nil when logged out
        let currentUser = PFUser.currentUser()
        
        XCTAssertNil(currentUser, "current user is nil")
        
        // log in 
        userManager!.loginUserWithPass(user, password: pass, finished: { (error) -> () in
            //currentUser should be not nil when logged in
            let currentUser = PFUser.currentUser()
            XCTAssertNil(error, "error must be nil")
            XCTAssertNotNil(currentUser, "current user is not nil")
            
        })
        
    }
    
    func test_userHasCorrespondingPlayerObject_works() {
        
        let userManager: Optional<AnyObject> = ServiceLocator.sharedInstance.get(UserManagerProtocol)
        userManager?.initialize({ (finished) -> () in
            let player = userManager?.getCurrentPlayer()
            XCTAssertNotNil(player, "player object should be there")
        })

    }
    
    func test_userLogoutWorks_works() {
        
        let userManager: Optional<AnyObject> = ServiceLocator.sharedInstance.get(UserManagerProtocol)
        userManager!.logoutUser()
        //currentUser should be nil when logged out
        let currentUser = PFUser.currentUser()
        XCTAssertNil(currentUser, "user must be nil")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
