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
    let totemComponentSystem = GKComponentSystem(componentClass: TotemSpellComponent.self)
    
    let islandNode:MapIslandNode
    
    init(islandNode:MapIslandNode) {
        self.islandNode = islandNode
    }
    
    func makeBoltSpell(spell:SpellModel,caster:GridEntity,target:SCNNode) -> SpellEntity {
        let casterNode = (caster.component(ofType: GKSCNNodeComponent.self)?.node)!
        
        //Create geometry
        let sphereSize = CGFloat(spell.damage()) * 0.03
        let geometry = SCNSphere(radius: sphereSize)
        geometry.firstMaterial = MaterialProvider.floorMaterial()
        let node = SCNNode(geometry: geometry)
        node.position = casterNode.position
        
        //Create spell entity
        let entity = SpellEntity(model: spell,caster:caster, node:node, target:target)
        
        let trail = SCNParticleSystem.flSystem(named: spell.particleFileName())!
        trail.emitterShape = geometry
        node.addParticleSystem(trail)
        return entity
    }
    
    func makePersonalSpell(spell:SpellModel,caster:GridEntity) -> SpellEntity {
        let casterNode = (caster.component(ofType: GKSCNNodeComponent.self)?.node)!
        
        let geometry = SCNSphere(radius: 2.25)
        //geometry.firstMaterial = MaterialProvider.floorMaterial()
        let node = SCNNode()
        node.position = casterNode.position
        
        let entity = SpellEntity(model: spell,caster:caster, node:node)
        livingSpells.append(entity)
        
        let trail = SCNParticleSystem.flSystem(named: spell.particleFileName())!
        trail.emitterShape = geometry
        trail.particleCharge = -1
        trail.isAffectedByPhysicsFields = true
        trail.particleColor = UIColor.purple
        node.addParticleSystem(trail)
        
        let field = SCNPhysicsField.radialGravity()
        field.strength = 10
        node.physicsField = field
        
        let fieldGeometry = SCNSphere(radius: 0.2)
        let physicsShape = SCNPhysicsShape(geometry: fieldGeometry, options: nil)
        node.physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        
        entity.addComponent(SpellEffectComponent(target:caster))
        return entity
    }
    
    func makeTotemSpell(spell:SpellModel,caster:GridEntity) -> SpellEntity {
        let cornerIndex = TotemSpellComponent.nextCornerIndex(spells: livingSpells, gridPosition: caster.gridPosition)!
        let landNode = self.islandNode.node(at: caster.gridPosition)
        
        let totemComponent = TotemSpellComponent(landNode:landNode.dungeonNode, cornerIndex: cornerIndex)
        let spellNode = TotemSpellComponent.makeNode()
        let entity = SpellEntity(model: spell,caster:caster, node:spellNode)
        entity.addComponent(SpellEffectComponent(target:nil))
        entity.addComponent(totemComponent)
        
        totemComponent.positionAtCorner(squarePosition: landNode.position)
        return entity
    }
    
    func addSpellToWorld(entity:SpellEntity) {
        livingSpells.append(entity)
        removalComponentSystem.addComponent(foundIn: entity)
        moveComponentSystem.addComponent(foundIn: entity)
        effectComponentSystem.addComponent(foundIn: entity)
        totemComponentSystem.addComponent(foundIn:entity)
        
        islandNode.addChildNode(entity.component(ofType: GKSCNNodeComponent.self)!.node)
        entity.component(ofType: SpellMovementComponent.self)?.setInitialVelocity()
    }
    
    func removeSpell(spell:SpellEntity) {
        livingSpells = livingSpells.filter { $0 != spell}
        removalComponentSystem.removeComponent(foundIn: spell)
        moveComponentSystem.removeComponent(foundIn: spell)
        effectComponentSystem.removeComponent(foundIn:spell)
        totemComponentSystem.removeComponent(foundIn:spell)
        
        let nodeComponent = spell.component(ofType: GKSCNNodeComponent.self)
        nodeComponent?.node.removeFromParentNode()
    }
    
    func update(deltaTime seconds: TimeInterval) {
        removalComponentSystem.update(deltaTime: seconds)
        moveComponentSystem.update(deltaTime: seconds)
        totemComponentSystem.update(deltaTime: seconds)
        effectComponentSystem.update(deltaTime: seconds)
        let expired = livingSpells.filter { $0.component(ofType: SpellExpirationComponent.self)!.hasExpired() }
        for e in expired {
            self.removeSpell(spell: e)
        }
    }
    
    func reset() {
        for e in self.livingSpells {
            self.removeSpell(spell: e)
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
        guard let component = character.component(ofType: CharacterComponent.self) else { return }
        let damage = spell.model.damage()
        component.takeDamage(damage: damage)
        let casterEvents = spell.caster.component(ofType: CharacterEventComponent.self)
        casterEvents?.dealtDamage(amount: damage)
        if component.isDead() {
            casterEvents?.killedEnemy()
        }
    }
    
    func spellsTargeting(entity:GridEntity) -> [SpellEntity] {
        let entityNode = (entity.component(ofType: GKSCNNodeComponent.self)?.node)!
        return self.livingSpells.filter { (spell) -> Bool in
            return spell.target === entityNode
        }
    }
    
}
