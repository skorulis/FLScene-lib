//
//  SustainedActionComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/9/18.
//

import GameplayKit

class SustainedActionComponent: GKComponent {

    private var currentAction:ActionType?
    
    func startAction(action:ActionType) {
        self.currentAction = action
    }
    
    func stopAction() {
        self.currentAction = nil
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if currentAction == nil {
            return
        }
        print("Action")
    }
    
}
