//
//  NPCComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 1/9/18.
//

import GameplayKit

class NPCComponent: GKComponent {

    let npc:NonPlayerCharacterModel
    
    init(npc:NonPlayerCharacterModel) {
        self.npc = npc
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let node = entity?.component(ofType: GKSCNNodeComponent.self)?.node as? FLMapSprite else { return }
        if npc.quests.count > 0 {
            node.updateInfoIcon(text: "!")
        }
    }
    
}
