//
//  CharacterManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class CharacterManager: NSObject {

    private var characters:[GridEntity] = []
    
    func add(character:GridEntity) {
        character.addComponent(CharacterComponent())
        self.characters.append(character)
    }
    
}
