//
//  Bootstrapper.swift
//  Kickerific
//
//  Created by Mario on 15.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation

class Bootstrapper {
    
    private static func initializeServices() {
        
        /*log.debug("[Bootstrapper] initializeServices()")
        ServiceLocator.sharedInstance.set(IConfigurationManager.self, instance:ConfigurationManager())
        */
    }
    
}

@objc class Managers {
    
    /*
    class var Widget : IWidgetManager {
        get {
            return ServiceLocator.sharedInstance.get(IWidgetManager.self) as! IWidgetManager
        }
    }
    
    /*
    class var Navigation : INavigationManager {
    get {
    return ServiceLocator.sharedInstance.get(INavigationManager.self) as! INavigationManager
    }
    }
    */
    
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