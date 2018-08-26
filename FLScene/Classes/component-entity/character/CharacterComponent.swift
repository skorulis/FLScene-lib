//
//  CharacterComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class CharacterComponent: GKComponent {

    let character:BattleCharacter
    
    init(character:BattleCharacter) {
        self.character = character
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sprite() -> FLMapSprite {
        let sprite = entity?.component(ofType: GKSCNNodeComponent.self)?.node as? FLMapSprite
        return sprite!
    }
    
    func takeDamage(damage:Int) {
        character.health -= damage
        sprite().updateHealthBar(pct:character.health.fullPercentage)
    }
    
    func takeMana(amount:Int) {
        character.mana -= amount
        sprite().updateManaBar(pct: character.mana.fullPercentage)
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
        return character.mana.value >= cost
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
    
    func isDead() -> Bool {
        return self.character.health.value == 0
    }
    
}
