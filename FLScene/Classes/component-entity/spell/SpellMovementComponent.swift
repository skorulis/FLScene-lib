//
//  SpellMovementComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellMovementComponent: GKComponent {
    
    func spellEntity() -> SpellEntity {
        return self.entity as! SpellEntity
    }
    
    func setInitialVelocity() {
        let spellNode = self.spellEntity().node()
        let geometry = spellNode.geometry!
        
        let direction = (spellEntity().target.worldPosition - spellNode.worldPosition).normalized()
        
        let physicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
        spellNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        spellNode.physicsBody?.velocity = direction * 10
        spellNode.physicsBody?.isAffectedByGravity = false
    }
    
}
