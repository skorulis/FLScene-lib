//
//  SpellManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import Foundation
import GameplayKit

class SpellManager: NSObject {

    var livingSpells:[SpellEntity] = []
    let removalComponentSystem = GKComponentSystem(componentClass: SpellExpirationComponent.self)
    let moveComponentSystem = GKComponentSystem(componentClass: SpellMovementComponent.self)
    
    func addSpell(spell:SpellModel,caster:SCNNode,target:SCNNode, inScene scene:SCNScene) {
        
        //Create geometry
        let geometry = SCNSphere(radius: 0.25)
        geometry.firstMaterial = MaterialProvider.floorMaterial()
        let node = SCNNode(geometry: geometry)
        node.position = caster.position
        scene.rootNode.addChildNode(node)
        
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
        if (seconds > 0.1) {
            return //Animation was probably paused
        }
        removalComponentSystem.update(deltaTime: seconds)
        moveComponentSystem.update(deltaTime: seconds)
        let expired = livingSpells.filter { $0.component(ofType: SpellExpirationComponent.self)!.hasExpired() }
        expired.forEach { (spell) in
            self.removeSpell(spell: spell)
        }
    }
    
}
