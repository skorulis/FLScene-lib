//
//  SpellManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import Foundation
import GameplayKit

extension SCNPhysicsContact {
    
    func spellNode() -> SCNNode {
        if nodeA.entity?.isKind(of: SpellEntity.self) ?? false {
            return nodeA
        }
        return nodeB
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
    
    func addSpell(spell:SpellModel,caster:SCNNode,target:SCNNode) {
        
        //Create geometry
        let geometry = SCNSphere(radius: 0.25)
        geometry.firstMaterial = MaterialProvider.floorMaterial()
        let node = SCNNode(geometry: geometry)
        node.position = caster.position
        caster.parent!.addChildNode(node)
        
        //Create spell entity
        let entity = SpellEntity(model: spell,node:node, target:target)
        
        let trail = SCNParticleSystem.flSystem(named: "trail")!
        trail.emitterShape = geometry
        node.addParticleSystem(trail)
        
        livingSpells.append(entity)
        entity.manager = self
        removalComponentSystem.addComponent(foundIn: entity)
        moveComponentSystem.addComponent(foundIn: entity)
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
        let expired = livingSpells.filter { $0.component(ofType: SpellExpirationComponent.self)!.hasExpired() }
        expired.forEach { (spell) in
            self.removeSpell(spell: spell)
        }
    }
    
    func handleContact(contact:SCNPhysicsContact) {
        let spellNode = contact.spellNode()
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
        component?.takeDamage(damage: spell.model.damagePoints)
    }
    
}
