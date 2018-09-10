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
        self.node()?.addChildNode(indicator)
        let fade = SCNAction.fadeOut(duration: 1)
        let remove = SCNAction.removeFromParentNode()
        let sequence = SCNAction.sequence([fade,remove])
        
        indicator.runAction(sequence)
    }
    
    override func wasAddedToManager(manager:CharacterManager) {
        events()?.getItemObservers.add(object: self, {[weak self] (item) in
            self?.showIndicator()
        })
    }
    
}
