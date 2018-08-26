//
//  SpellEffectComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 20/8/18.
//

import GameplayKit

class SpellEffectComponent: SpellComponent {

    weak var targetEntity:GridEntity?
    
    init(target:GridEntity? = nil) {
        self.targetEntity = target
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        let characterComponent = targetEntity?.component(ofType: CharacterComponent.self)
        characterComponent?.addMana(amount: spellModel().manaRate() * Float(seconds))
        characterComponent?.heal(amount: spellModel().healingRate() * Float(seconds))
    }
    
}
