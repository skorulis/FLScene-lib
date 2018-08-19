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
    
    private func sprite() -> FLSpriteComponent {
        return (self.entity?.component(ofType: FLSpriteComponent.self))!
    }
    
    func takeDamage(damage:Int) {
        character.health -= damage
        sprite().sprite.updateHealthBar(pct:character.health.fullPercentage)
    }
    
    func takeMana(amount:Int) {
        character.mana -= amount
        sprite().sprite.updateManaBar(pct: character.mana.fullPercentage)
    }
    
    func hasMana(cost:Int) -> Bool {
        return character.mana.value >= cost
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let manaBefore = character.mana.value
        character.mana += Float(seconds) * 2
        //Don't do an update if nothing has changed
        if (manaBefore != character.mana.value) {
            sprite().sprite.updateManaBar(pct: character.mana.fullPercentage)
        }
    }
    
}
