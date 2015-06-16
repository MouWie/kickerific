//
//  UserManagerProtocol.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation

@objc protocol UserManagerProtocol {
    
    func getPlayerForUser(userID: String) -> AnyObject
    
    
}