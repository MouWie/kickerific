//
//  Bootstrapper.swift
//  Kickerific
//
//  Created by Mario on 15.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation

public class Bootstrapper {
    
    public static func initializeServices() {
        
        //log.debug("[Bootstrapper] initializeServices()")
        ServiceLocator.sharedInstance.set(GameManagerProtocol.self, instance:GameManager())
        ServiceLocator.sharedInstance.set(UserManagerProtocol.self, instance: UserManager())
    }
    
    public static func initializeParseFunctions() {
        
        Player.initialize()
        Player.registerSubclass()
        
        Match.initialize()
        Match.registerSubclass()
        
        Team.initialize()
        Team.registerSubclass()
    }
    
}

@objc class Managers {
    
    
    class var Game : GameManagerProtocol {
        get {
            return ServiceLocator.sharedInstance.get(GameManagerProtocol.self) as! GameManagerProtocol
        }
    }
    
    class var User: UserManagerProtocol {
        get {
            return ServiceLocator.sharedInstance.get(UserManagerProtocol.self) as! UserManagerProtocol
        }
    }
    
    /*
    class var Navigation : INavigationManager {
    get {
    return ServiceLocator.sharedInstance.get(INavigationManager.self) as! INavigationManager
    }
    }
    
    
    class var Messenger : IMessenger {
        get {
            return ServiceLocator.sharedInstance.get(IMessenger.self) as! IMessenger
        }
    }
    
    class var Screen : IScreenManager {
        get {
            return ServiceLocator.sharedInstance.get(IScreenManager.self) as! IScreenManager
        }
    }
    */
    

}