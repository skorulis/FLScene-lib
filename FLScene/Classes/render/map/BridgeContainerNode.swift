//
//  BridgeContainerNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 28/8/18.
//

import SceneKit

public class BridgeContainerNode: SCNNode {

    var bridges:[BridgeNode] = []
    
    func buildNodes(bridgeModels:[BridgeModel],overland:OverlandScene) {
        self.bridges.forEach { $0.removeFromParentNode() }
        self.bridges.removeAll()
        
        for model in bridgeModels {
            let islandModel1 = overland.island(named: model.firstIslandName)
            let islandModel2 = overland.island(named: model.secondIslandName)
            
            let island1 = overland.islandFor(dungeon: islandModel1)
            let island2 = overland.islandFor(dungeon: islandModel2)
            
            let node1 = island1.node(at: model.firstGridPosition)
            let node2 = island2.node(at: model.secondGridPosition)
            
            let bridgeNode = BridgeNode(from: node1, to: node2, model:model)
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
    
    func bridge(with model:BridgeModel) -> BridgeNode {
        return self.bridges.filter { (bridge) -> Bool in
            return bridge.model.firstIslandName == model.firstIslandName && bridge.model.secondIslandName == model.secondIslandName
        }.first!
    }
    
}
