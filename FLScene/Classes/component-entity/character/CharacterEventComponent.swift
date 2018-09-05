//
//  CharacterEventComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 3/9/18.
//

import GameplayKit

class CharacterEventComponent: GKComponent {

    private var damageDone:Int = 0
    private var damageReceived:Int = 0
    private var manaSpent:Int = 0
    private var killCount:Int = 0
    private var healingCast:Float = 0
    private var wastedDamage:Float = 0
    private var spellsUsed:[SpellType:Int] = [:]
    
    func printResults() {
        print("----Character stats----")
        print("damage done: \(damageDone)")
        print("Damage received: \(damageReceived)")
        print("Mana spent: \(manaSpent)")
        print("Kill count: \(killCount)")
        print("healing Cast: \(healingCast)")
        print("Wasted damage: \(wastedDamage)")
        print("Spells cast: \(spellsUsed)")
        print("---------")
    }
    
    func receivedDamage(amount:Int) {
        self.damageReceived += amount
    }
    func wastedDamage(amount:Int) {
        self.wastedDamage += Float(wastedDamage)
    }
    
    func dealtDamage(amount:Int) {
        self.damageDone += amount
    }
    
    func spendMana(amount:Int) {
        self.manaSpent += amount
    }
    
    func killedEnemy() {
        self.killCount  = self.killCount + 1
    }
    
    func didHeal(amount:Float) {
        healingCast += amount
    }
    
    func castSpell(spell:SpellModel) {
        if let oldCount = spellsUsed[spell.type] {
            spellsUsed[spell.type] = oldCount + 1
        } else {
            spellsUsed[spell.type] = 1
        }
    }
    
}
