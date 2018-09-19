//
//  OverlandAIComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/9/18.
//

import GameplayKit

class OverlandAIComponent: BaseEntityComponent {

    let overland:FullOverlandModel
    
    init(overland:FullOverlandModel) {
        self.overland = overland
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var movement:MovementComponent {
        return gridEntity().component(ofType: MovementComponent.self)!
    }
    var actionQueue:ActionQueueComponent {
        return gridEntity().component(ofType: ActionQueueComponent.self)!
    }
    var sustainedAction:SustainedActionComponent {
        return gridEntity().component(ofType: SustainedActionComponent.self)!
    }
    
    func isBusy() -> Bool {
        return movement.isMoving || sustainedAction.isBusy() || actionQueue.isBusy()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard !isBusy() else { return }
        let island = overland.findIsland(name: self.location().islandName!)
        
    }
    
}
