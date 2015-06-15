//
//  ServiceLocator.swift
//  Kickerific
//
//  Created by Mario on 15.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation

/**
Basic service locator implementation in swift
*/
public class ServiceLocator {
    
    /*internal struct The {
    static let Instance : ServiceLocator = ServiceLocator()
    }*/
    
    public static let sharedInstance: ServiceLocator = ServiceLocator()
    
    
    
    private var hash = Dictionary<String,AnyObject>()
    
    /**
    Retrieves a specified instance form the service locator
    
    - parameter klass: The class/protocol to retrieve
    
    - returns:   The instance (will throw exception if instance cannot be found)
    */
    func get(klass: Protocol) -> Optional<AnyObject> {
        let type = NSStringFromProtocol(klass)
        
        for (key,value) in hash {
            if key == type {
                return value
            }
        }
        
        return nil
    }
    
    /**
    Registeres a new instance in the service locator
    
    - parameter instance: The instance to be registered
    */
    func set(klass: Protocol, instance: AnyObject) {
        
        let type = NSStringFromProtocol(klass)
        hash[type] = instance
        
    }
    
    func clear() {
        hash.removeAll(keepCapacity: false)
    }
    
}