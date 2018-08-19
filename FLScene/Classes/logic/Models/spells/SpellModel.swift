//
//  SpellModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import Foundation

enum SpellType: String, Codable {
    case bolt
    case teleport
}

class SpellModel: Codable {

    let type:SpellType
    
    //Points allocated to various aspects of the spell
    var speedPoints:Int = 1
    var damagePoints:Int = 1
    var rangePoints:Int = 1
    var homingPoints:Int = 0
    
    static let speedMultiplier:Float = 5
    static let rangeMultiplier:Float = 6
    
    init(type:SpellType) {
        self.type = type
    }
    
    func cost() -> Int {
        switch (type) {
        case .bolt:
            return speedPoints + damagePoints + rangePoints
        case .teleport:
            return rangePoints * 3
        }
        
    }
    
    func speed() -> Float {
        return Float(speedPoints) * SpellModel.speedMultiplier
    }
    
    func range() -> Float {
        return Float(rangePoints) * SpellModel.rangeMultiplier
    }
    
    func inaccuracy() -> Float {
        return 0.1
    }
    
}
