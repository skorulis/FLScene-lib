//
//  SpellExpirationComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellExpirationComponent: GKComponent {

    var lifeUsed:TimeInterval = 0
    
    func spellEntity() -> SpellEntity {
        return self.entity as! SpellEntity
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        lifeUsed += seconds
    }
    
    func hasExpired() -> Bool {
        return lifeUsed >= TimeInterval(spellEntity().model.maxLife)
    }
    
}
