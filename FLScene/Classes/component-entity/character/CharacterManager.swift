//
//  CharacterManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class CharacterManager: NSObject {

    private var characters:[GridEntity] = []
    let characterComponentSystem = GKComponentSystem(componentClass: CharacterComponent.self)
    let aiComponentSystem = GKComponentSystem(componentClass: BattleAIComponent.self)
    
    let spellManager:SpellManager
    
    init(spellManager:SpellManager) {
        self.spellManager = spellManager
        super.init()
    }
    
    func add(entity:GridEntity) {
        entity.addComponent(SpellCastingComponent(spellManager: spellManager))
        self.characters.append(entity)
        
        characterComponentSystem.addComponent(foundIn: entity)
        aiComponentSystem.addComponent(foundIn: entity)
    }
    
    func update(deltaTime seconds: TimeInterval) {
        characterComponentSystem.update(deltaTime: seconds)
        aiComponentSystem.update(deltaTime: seconds)
    }
    
}
