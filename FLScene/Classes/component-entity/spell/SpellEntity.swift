//
//  SpellEntity.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellEntity: GKEntity {

    let model:SpellModel
    let target:SCNNode
    weak var manager:SpellManager?
    
    init(model:SpellModel,node:SCNNode, target:SCNNode) {
        self.model = model
        self.target = target
        super.init()
        
        node.entity = self
        
        let removal = SpellExpirationComponent()
        self.addComponent(removal)
        
        let nodeComponent = GKSCNNodeComponent(node: node)
        self.addComponent(nodeComponent)
        
        let movement = SpellMovementComponent()
        self.addComponent(movement)
        movement.setInitialVelocity()
        
    }
    
    func node() -> SCNNode {
        return self.component(ofType: GKSCNNodeComponent.self)!.node
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
