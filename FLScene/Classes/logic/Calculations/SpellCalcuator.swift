//
//  SpellCalcuator.swift
//  Pods
//
//  Created by Alexander Skorulis on 5/9/18.
//

import Foundation

class SpellCalcuator: NSObject {

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
    
}
