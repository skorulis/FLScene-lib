//
//  SpellModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import Foundation

enum SpellType: String, Codable {
    case bolt
    case beam
    case teleport
    case shield
    case heal
    case channelMana
    case buff
}

class SpellModel: Codable {

    let type:SpellType
    
    //Points allocated to various aspects of the spell
    var speedPoints:Int = 1
    var powerPoints:Int = 1
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
            return speedPoints + powerPoints + rangePoints
        case .teleport:
            return rangePoints * 3
        default:
            return powerPoints //Not yet implemented
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
    
    func isChannelSpell() -> Bool {
        return self.type == .heal || self.type == .channelMana
    }
    
    func healingRate() -> Float {
        return Float(self.powerPoints) * 3
    }
    
    func manaRate() -> Float {
        return Float(self.powerPoints) * 3
    }
    
    func damage() -> Int {
        return self.powerPoints * 3
    }
    
    func particleFileName() -> String {
        switch (type) {
        case .bolt:
            return "trail"
        default:
            return "focus"
        }
    }
    
}
