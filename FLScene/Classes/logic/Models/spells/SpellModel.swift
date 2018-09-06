//
//  SpellModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import Foundation

enum SpellType: String, Codable {
    case bolt //A bolt that flies straight at an enemy
    case channel //Constant cast on the player
    case totem //Totem that gets placed in the square
    case teleport
    case buff //A beneficial spell cast at the current player
    /*case beam
     case blast
     case cloud
    case shield*/
}

enum SpellEffectType: String, Codable {
    case heal
    case mana
    case damage
}

class SpellModel: Codable {

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case effects
        case speedPoints
        case powerPoints
        case rangePoints
        case homingPoints
        
    }
    
    var name:String
    let type:SpellType
    let effects:[SpellEffectType]
    let spellId:String = UUID().uuidString
    
    //Points allocated to various aspects of the spell
    var speedPoints:Int = 1
    var powerPoints:Int = 1
    var rangePoints:Int = 1
    var homingPoints:Int = 0
    
    static let speedMultiplier:Float = 5
    static let rangeMultiplier:Float = 6
    
    init(type:SpellType,effect:SpellEffectType) {
        self.type = type
        self.effects = [effect]
        self.name = "none"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey:.name)
        if let existing = ReferenceController.instance.namedSpells[self.name] {
            self.type = existing.type
            self.effects = existing.effects
            self.speedPoints = existing.speedPoints
            self.powerPoints = existing.powerPoints
            self.rangePoints = existing.rangePoints
            self.homingPoints = existing.homingPoints
        } else {
            self.type = try container.decodeIfPresent(SpellType.self, forKey: .type) ?? .bolt
            self.effects = try container.decodeIfPresent([SpellEffectType].self, forKey: .effects) ?? [.damage]
            self.speedPoints = try container.decodeIfPresent(Int.self, forKey: .speedPoints) ?? 1
            self.powerPoints = try container.decodeIfPresent(Int.self, forKey: .powerPoints) ?? 1
            self.rangePoints = try container.decodeIfPresent(Int.self, forKey: .rangePoints) ?? 1
            self.homingPoints = try container.decodeIfPresent(Int.self, forKey: .homingPoints) ?? 0
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
        return self.type == .channel
    }
    
    func healingRate() -> Float {
        guard self.effects.contains(.heal) else { return 0 }
        return Float(self.powerPoints) * 3
    }
    
    func manaRate() -> Float {
        guard self.effects.contains(.mana) else { return 0 }
        return Float(self.powerPoints) * 3
    }
    
    func homingRate() -> Float {
        return Float(self.homingPoints) * 5
    }
    
    func cooldown() -> TimeInterval {
        return 0.3
    }
    
    //Only relevant to totems, maybe shields
    func maxAge() -> TimeInterval {
        return 10
    }
    
    func particleFileName() -> String {
        switch (type) {
        case .bolt:
            return "trail"
        default:
            return "heal"
        }
    }
    
}
