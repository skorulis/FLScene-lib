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
        
        var direction = (spellEntity().target!.worldPosition - spellNode.worldPosition)
        direction = direction.normalized()
        direction += SCNVector3(rX,rY,rZ)
        
        let shapeOptions = [SCNPhysicsShape.Option.collisionMargin:0.0]
        let physicsShape = SCNPhysicsShape(geometry: geometry, options: shapeOptions)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        physicsBody.velocity = direction * Float(spellEntity().model.speed())
        physicsBody.isAffectedByGravity = false
        physicsBody.categoryBitMask = 1
        physicsBody.collisionBitMask = 0
        physicsBody.contactTestBitMask = 1
        
        spellNode.physicsBody = physicsBody
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let homing = self.spellEntity().model.homingRate()
        let node = self.spellEntity().node()
        if homing > 0 {
            let speed = self.spellEntity().model.speed()
            let direction = (self.spellEntity().target!.position - node.presentation.position).normalized()
            let change = direction * homing * Float(seconds)
            node.physicsBody!.velocity += change
            if (node.physicsBody!.velocity.magnitude() > speed) {
                node.physicsBody!.velocity = node.physicsBody!.velocity.normalized() * speed
            }
        }
    }
    
}
