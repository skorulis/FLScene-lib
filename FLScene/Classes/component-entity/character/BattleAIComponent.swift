//
//  BattleAIComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class BattleAIComponent: GKComponent {

    override func update(deltaTime seconds: TimeInterval) {
        guard let characterComponent = self.entity?.component(ofType: CharacterComponent.self) else { return }
        guard characterComponent.hasMana(cost: 10) else { return }
        
        guard let spellCasting = self.entity?.component(ofType: SpellCastingComponent.self) else { return }
        spellCasting.castSpell(index: 0)
    }
    
}
