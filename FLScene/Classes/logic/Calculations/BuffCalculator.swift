//
//  BuffCalculator.swift
//  Pods
//
//  Created by Alexander Skorulis on 6/9/18.
//

import Foundation

class BuffCalculator {

    var character:CharacterModel?
    
    var buffs:[BuffModel] {
        return self.character?.buffs ?? []
    }
    
    func damageMultiplier() -> Float {
        var total:Float = 1
        for b in buffs {
            if b.effect == .damage {
                total += Float(b.powerPoints)
            }
        }
        return total
    }
    
}
