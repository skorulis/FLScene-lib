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
    
    func add(character:GridEntity) {
        character.addComponent(CharacterComponent())
        self.characters.append(character)
        characterComponentSystem.addComponent(foundIn: character)
    }
    
    func update(deltaTime seconds: TimeInterval) {
        characterComponentSystem.update(deltaTime: seconds)
    }
    
}
