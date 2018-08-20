//
//  SpellEffectComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 20/8/18.
//

import GameplayKit

class SpellEffectComponent: GKComponent {

    func spellEntity() -> SpellEntity {
        return self.entity as! SpellEntity
    }
    
    func model() -> SpellModel {
        return spellEntity().model
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let characterComponent = spellEntity().caster.component(ofType: CharacterComponent.self)
        characterComponent?.addMana(amount: model().manaRate() * Float(seconds))
        characterComponent?.heal(amount: model().healingRate() * Float(seconds))
    }
    
}
