//
//  GameManagerProtocol.swift
//  Kickerific
//
//  Created by Mario on 16.06.15.
//  Copyright (c) 2015 mantro.net. All rights reserved.
//

import Foundation


@objc protocol GameManagerProtocol {
    
    func setupGame(players1: Array<Player>, players2: Array<Player>)
    
    
}