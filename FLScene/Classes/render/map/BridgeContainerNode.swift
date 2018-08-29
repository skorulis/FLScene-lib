//
//  BridgeContainerNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 28/8/18.
//

import SceneKit

class BridgeContainerNode: SCNNode {

    var bridges:[BridgeNode] = []
    
    func buildNodes(bridgeModels:[BridgeModel],overland:OverlandScene) {
        self.bridges.forEach { $0.removeFromParentNode() }
        self.bridges.removeAll()
        
        for model in bridgeModels {
            let islandModel1 = overland.island(named: model.firstIslandName)
            let islandModel2 = overland.island(named: model.secondIslandName)
            
            let island1 = overland.islandFor(dungeon: islandModel1)
            let island2 = overland.islandFor(dungeon: islandModel2)
            
            let node1 = island1.node(at: model.fistGridPosition)
            let node2 = island2.node(at: model.secondGridPosition)
            
            let bridgeNode = BridgeNode(from: node1, to: node2)
            self.addChildNode(bridgeNode)
            bridges.append(bridgeNode)
            
            print("Load bridge")
        }
    }
    
    func updateBridges() {
        for bridge in bridges {
            bridge.updateStones()
        }
    }
    
}
