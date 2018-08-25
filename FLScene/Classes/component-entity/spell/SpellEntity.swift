//
//  SpellEntity.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellEntity: GKEntity {

    let model:SpellModel
    let target:SCNNode?
    let caster:GridEntity
    
    init(model:SpellModel,caster:GridEntity,node:SCNNode, target:SCNNode? = nil) {
        self.model = model
        self.caster = caster
        self.target = target
        super.init()
        
        node.entity = self
        
        let removal = SpellExpirationComponent()
        self.addComponent(removal)
        
        let nodeComponent = GKSCNNodeComponent(node: node)
        self.addComponent(nodeComponent)
        
        if target != nil {
            let movement = SpellMovementComponent()
            self.addComponent(movement)
            movement.setInitialVelocity()
        }
        
    }
    
    func node() -> SCNNode {
        return self.component(ofType: GKSCNNodeComponent.self)!.node
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SpellComponent: GKComponent {
    
    func spellEntity() -> SpellEntity {
        return self.entity as! SpellEntity
    }
    
    func spellModel() -> SpellModel {
        return spellEntity().model
    }
    
    func spellNode() -> SCNNode? {
        return self.entity?.component(ofType: GKSCNNodeComponent.self)?.node
    }
}
