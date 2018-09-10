//
//  RewardVisualisationComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/9/18.
//

import GameplayKit

class RewardVisualisationComponent: BaseEntityComponent {
    
    private var currentIndicator:RewardIndicatorNode?
    
    func showIndicator() {
        let indicator = RewardIndicatorNode()
        indicator.position = SCNVector3(0,1.2,0)
        indicator.opacity = 0
        self.node()?.addChildNode(indicator)
        
        let fadeIn = SCNAction.fadeIn(duration: 0.2)
        let move = SCNAction.move(by: SCNVector3(0,2,0), duration: 2)
        let delay = SCNAction.wait(duration: 1)
        let fade = SCNAction.fadeOut(duration: 1)
        let remove = SCNAction.removeFromParentNode()
        let sequence = SCNAction.sequence([delay,fade,remove])
        
        indicator.runAction(fadeIn)
        indicator.runAction(move)
        indicator.runAction(sequence)
    }
    
    override func wasAddedToManager(manager:CharacterManager) {
        events()?.getItemObservers.add(object: self, {[weak self] (item) in
            self?.showIndicator()
        })
    }
    
}
