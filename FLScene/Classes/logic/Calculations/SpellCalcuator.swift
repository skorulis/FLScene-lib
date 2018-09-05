//
//  SpellCalcuator.swift
//  Pods
//
//  Created by Alexander Skorulis on 5/9/18.
//

import Foundation

class SpellCalcuator: NSObject {

    private let buffCalc = BuffCalculator()
    
    var character:CharacterModel? {
        didSet {
            buffCalc.character = character
        }
    }
    
    func spellCost(spell:SpellModel) -> Int {
        switch (spell.type) {
        case .bolt:
            return spell.speedPoints + spell.powerPoints + spell.rangePoints + spell.homingPoints
        case .teleport:
            return spell.rangePoints * 3
        case .buff:
            return spell.powerPoints * 5
        default:
            return spell.powerPoints //Not yet implemented
        }
    }
    
    func castingTime(spell:SpellModel) -> TimeInterval {
        if spell.isChannelSpell() {
            return 0
        }
        switch spell.type {
        case .totem:
            return 2
        case .buff:
            return 1 * TimeInterval(spell.powerPoints)
        default:
            return 0.3 * TimeInterval(spell.powerPoints)
        }
    }
    
    func damage(spell:SpellModel) -> Int {
        if spell.type == .buff {
            return 0
        }
        guard spell.effects.contains(.damage) else { return 0 }
        let multiplier = buffCalc.damageMultiplier()
        
        return Int(Float(spell.powerPoints * 3) * multiplier)
    }
    
    func generateBuff(spell:SpellModel) -> BuffModel {
        let effect = spell.effects[0]
        return BuffModel(time: 10, effect: effect, power: spell.powerPoints)
    }
    
    func stats(spell:SpellModel) -> SpellStatsModel {
        let stats = SpellStatsModel()
        stats.damage = damage(spell: spell)
        return stats
    }
    
}
