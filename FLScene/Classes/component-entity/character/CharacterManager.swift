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
    
    func add(character:BattleCharacter, entity:GridEntity) {
        entity.addComponent(CharacterComponent(character: character))
        self.characters.append(entity)
        characterComponentSystem.addComponent(foundIn: entity)
    }
    
    func update(deltaTime seconds: TimeInterval) {
        characterComponentSystem.update(deltaTime: seconds)
    }
    
}
