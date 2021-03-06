//
//  CharacterComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class CharacterComponent: BaseEntityComponent {

    let character:CharacterModel
    let playerNumber:Int
    var killCount:Int = 0
    var deathCount:Int = 0
    
    init(character:CharacterModel,playerNumber:Int) {
        self.character = character
        self.playerNumber = playerNumber
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sprite() -> SimpleBeingNode {
        let sprite = entity?.component(ofType: GKSCNNodeComponent.self)?.node as? SimpleBeingNode
        return sprite!
    }
    
    func takeDamage(damage:Int) {
        let wastedDamage = max(damage - character.health.valueInt,0)
        
        character.health -= damage
        sprite().updateHealthBar(pct:character.health.fullPercentage)
        
        events()?.receivedDamage(amount: damage)
        events()?.wastedDamage(amount: wastedDamage)
    }
    
    func takeMana(amount:Int) {
        character.mana -= amount
        sprite().updateManaBar(pct: character.mana.fullPercentage)
        events()?.spendMana(amount: amount)
    }
    
    func heal(amount:Float) {
        character.health += amount
        sprite().updateHealthBar(pct:character.health.fullPercentage)
    }
    
    func addMana(amount:Float) {
        character.mana += amount
        sprite().updateManaBar(pct: character.mana.fullPercentage)
    }
    
    func hasMana(cost:Int) -> Bool {
        return character.mana.valueInt >= cost
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let manaBefore = character.mana.value
        character.mana += Float(seconds) * 2
        //Don't do an update if nothing has changed
        if (manaBefore != character.mana.value) {
            sprite().updateManaBar(pct: character.mana.fullPercentage)
        }
    }
    
    func reset() {
        character.mana.setToMax()
        character.health.setToMax()
        sprite().updateManaBar(pct: character.mana.fullPercentage)
        sprite().updateHealthBar(pct:character.health.fullPercentage)
    }
    
    override func didAddToEntity() {
        //sprite().updateManaBar(pct: character.mana.fullPercentage)
        //sprite().updateHealthBar(pct:character.health.fullPercentage)
    }
    
    func isDead() -> Bool {
        return self.character.health.value == 0
    }
    
    func addBuff(buff:BuffModel) {
        self.character.buffs.append(buff)
    }
    
}
