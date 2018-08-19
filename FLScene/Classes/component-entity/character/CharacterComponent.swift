//
//  CharacterComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class CharacterComponent: GKComponent {

    private var health:MaxValueField = MaxValueField(maxValue: 20)
    private var mana:MaxValueField = MaxValueField(maxValue: 20)
    
    private func sprite() -> FLSpriteComponent {
        return (self.entity?.component(ofType: FLSpriteComponent.self))!
    }
    
    func takeDamage(damage:Int) {
        self.health -= damage
        sprite().sprite.updateHealthBar(pct:self.health.fullPercentage)
    }
    
    func takeMana(amount:Int) {
        self.mana -= amount
        sprite().sprite.updateManaBar(pct: self.mana.fullPercentage)
    }
    
    func hasMana(cost:Int) -> Bool {
        return self.mana.value >= cost
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let manaBefore = mana.value
        mana += Float(seconds) * 2
        //Don't do an update if nothing has changed
        if (manaBefore != mana.value) {
            sprite().sprite.updateManaBar(pct: self.mana.fullPercentage)
        }
    }
    
}
