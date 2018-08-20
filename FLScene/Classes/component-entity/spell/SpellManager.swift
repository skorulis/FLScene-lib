//
//  SpellManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import Foundation
import GameplayKit
import SKSwiftLib

extension SCNPhysicsContact {
    
    func spellNode() -> SCNNode? {
        if nodeA.entity?.isKind(of: SpellEntity.self) ?? false {
            return nodeA
        } else if nodeB.entity?.isKind(of: SpellEntity.self) ?? false {
            return nodeB
        }
        return nil
    }
    
    func otherNode(node:SCNNode) -> SCNNode {
        if node === nodeA {
            return nodeB
        }
        return nodeA
    }
    
}

class SpellManager: NSObject {

    var livingSpells:[SpellEntity] = []
    let removalComponentSystem = GKComponentSystem(componentClass: SpellExpirationComponent.self)
    let moveComponentSystem = GKComponentSystem(componentClass: SpellMovementComponent.self)
    let effectComponentSystem = GKComponentSystem(componentClass: SpellEffectComponent.self)
    
    func addSpell(spell:SpellModel,caster:GridEntity,target:SCNNode) -> SpellEntity {
        
        let casterNode = (caster.component(ofType: FLSpriteComponent.self)?.sprite)!
        
        //Create geometry
        let geometry = SCNSphere(radius: 0.25)
        geometry.firstMaterial = MaterialProvider.floorMaterial()
        let node = SCNNode(geometry: geometry)
        node.position = casterNode.position
        casterNode.parent!.addChildNode(node)
        
        //Create spell entity
        let entity = SpellEntity(model: spell,caster:caster, node:node, target:target)
        
        let trail = SCNParticleSystem.flSystem(named: spell.particleFileName())!
        trail.emitterShape = geometry
        node.addParticleSystem(trail)
        
        storeEntity(entity: entity)
        
        return entity
    }
    
    func addPersonalSpell(spell:SpellModel,caster:GridEntity) -> SpellEntity {
        let casterNode = (caster.component(ofType: FLSpriteComponent.self)?.sprite)!
        
        let geometry = SCNSphere(radius: 2.25)
        //geometry.firstMaterial = MaterialProvider.floorMaterial()
        let node = SCNNode()
        node.position = casterNode.position
        casterNode.parent!.addChildNode(node)
        
        let entity = SpellEntity(model: spell,caster:caster, node:node)
        livingSpells.append(entity)
        
        let trail = SCNParticleSystem.flSystem(named: spell.particleFileName())!
        trail.emitterShape = geometry
        trail.particleCharge = -1
        trail.isAffectedByPhysicsFields = true
        //trail.particleColor = UIColor.purple
        node.addParticleSystem(trail)
        
        let field = SCNPhysicsField.radialGravity()
        field.strength = 10
        node.physicsField = field
        
        let fieldGeometry = SCNSphere(radius: 0.2)
        let physicsShape = SCNPhysicsShape(geometry: fieldGeometry, options: nil)
        node.physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        
        entity.addComponent(SpellEffectComponent())
        
        storeEntity(entity: entity)
        
        return entity
    }
    
    private func storeEntity(entity:SpellEntity) {
        livingSpells.append(entity)
        removalComponentSystem.addComponent(foundIn: entity)
        moveComponentSystem.addComponent(foundIn: entity)
        effectComponentSystem.addComponent(foundIn: entity)
    }
    
    func removeSpell(spell:SpellEntity) {
        livingSpells = livingSpells.filter { $0 != spell}
        removalComponentSystem.removeComponent(foundIn: spell)
        moveComponentSystem.removeComponent(foundIn: spell)
        
        let nodeComponent = spell.component(ofType: GKSCNNodeComponent.self)
        nodeComponent?.node.removeFromParentNode()
    }
    
    func update(deltaTime seconds: TimeInterval) {
        removalComponentSystem.update(deltaTime: seconds)
        moveComponentSystem.update(deltaTime: seconds)
        effectComponentSystem.update(deltaTime: seconds)
        let expired = livingSpells.filter { $0.component(ofType: SpellExpirationComponent.self)!.hasExpired() }
        expired.forEach { (spell) in
            self.removeSpell(spell: spell)
        }
    }
    
    func handleContact(contact:SCNPhysicsContact) {
        let spellNode = contact.spellNode()!
        let spellEntity = spellNode.entity as! SpellEntity
        let other = contact.otherNode(node: spellNode)
        if other === spellEntity.target {
            spellEntity.component(ofType: SpellExpirationComponent.self)!.hitTarget = true
            let otherEntity = other.entity as! GridEntity
            applyDamage(spell: spellEntity, character: otherEntity)
        }
    }
    
    func applyDamage(spell:SpellEntity,character:GridEntity) {
        let component = character.component(ofType: CharacterComponent.self)
        component?.takeDamage(damage: spell.model.damage())
    }
    
}
