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
        
        let spell = spellEntity().model
        let rX = RandomHelpers.rand(min: -spell.inaccuracy(), max: spell.inaccuracy())
        let rY = RandomHelpers.rand(min: -spell.inaccuracy(), max: spell.inaccuracy())
        let rZ = RandomHelpers.rand(min: -spell.inaccuracy(), max: spell.inaccuracy())
        
        var direction = (spellEntity().target.worldPosition - spellNode.worldPosition)
        direction = direction.normalized()
        direction += SCNVector3(rX,rY,rZ)
        
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
