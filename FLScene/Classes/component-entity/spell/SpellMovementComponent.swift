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
        
        let shapeOptions = [SCNPhysicsShape.Option.collisionMargin:0.0]
        let physicsShape = SCNPhysicsShape(geometry: geometry, options: shapeOptions)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        physicsBody.velocity = direction * Float(spellEntity().model.speed())
        physicsBody.isAffectedByGravity = false
        physicsBody.collisionBitMask = 1
        physicsBody.categoryBitMask = 1
        physicsBody.contactTestBitMask = 1
        
        spellNode.physicsBody = physicsBody
    }
    
}
