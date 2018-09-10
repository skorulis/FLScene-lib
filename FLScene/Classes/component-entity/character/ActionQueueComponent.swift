//
//  ActionQueueComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 10/9/18.
//

import GameplayKit

public enum MovementStep {
    case tile(TileStep)
    case bridge(BridgeStep)
    case startAction(ActionType)
}

public struct TileStep {
    let position:vector_int2
    let dungeon:DungeonModel
}

public struct BridgeStep {
    let stoneIndex:Int
    let model:BridgeModel
}

class ActionQueueComponent: BaseEntityComponent {

    private var queuedSteps:[MovementStep] = []
    
    func moveAlong(steps:[MovementStep]) {
        let movement = (entity?.component(ofType: MovementComponent.self))!
        
        if steps.count == 0 || movement.isMoving {
            return
        }
        events()?.performedBlockingAction()
        
        let first = steps[0]
        self.queuedSteps = Array(steps.suffix(from: 1))
        switch first {
        case .tile(let step):
            movement.moveTo(position: step.position, inDungeon: step.dungeon)
        case .bridge(let step):
            movement.moveOnBridge(bridge: step.model, index: step.stoneIndex)
        case .startAction(let action):
            entity?.component(ofType: SustainedActionComponent.self)?.startAction(action: action)
        }
    }
    
    func consumeNext() {
        if queuedSteps.count > 0 {
            DispatchQueue.main.async {
                self.moveAlong(steps: self.queuedSteps)
            }
        }
    }
    
}
