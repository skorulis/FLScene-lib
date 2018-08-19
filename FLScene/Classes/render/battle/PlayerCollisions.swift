//
//  PlayerCollisions.swift
//  Pods
//
//  Created by Alexander Skorulis on 20/8/18.
//

import Foundation

class PlayerCollisions: NSObject {

    static func playerMask(number:Int) -> Int {
        return 2 << number
    }
    
    static func otherPlayerMask(number:Int) -> Int {
        if number == 1 {
            return playerMask(number:2)
        } else {
            return playerMask(number:1)
        }
    }
    
}
