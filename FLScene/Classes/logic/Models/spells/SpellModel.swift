//
//  SpellModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import Foundation

class SpellModel: Codable {

    //Points allocated to various aspects
    var maxLifePoints:Int = 1
    var speedPoints:Int = 1
    var damagePoints:Int = 1
    var rangePoints:Int = 1
    
    static let speedMultiplier:Float = 5
    static let rangeMultiplier:Float = 5
    
    func cost() -> Int {
        return maxLifePoints + speedPoints + damagePoints
    }
    
    func speed() -> Float {
        return Float(speedPoints) * SpellModel.speedMultiplier
    }
    
    func range() -> Float {
        return Float(rangePoints) * SpellModel.rangeMultiplier
    }
    
}
