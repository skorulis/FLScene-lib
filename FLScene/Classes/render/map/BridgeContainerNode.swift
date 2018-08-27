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
            let island1 = overland.island(named: model.firstIslandName)
            let island2 = overland.island(named: model.secondIslandName)
            
            let point1 = overland.pointFor(position: model.secondGridPosition, inDungeon: island1)
            let point2 = overland.pointFor(position: model.secondGridPosition, inDungeon: island2)
            
            let node = BridgeNode()
            let test1 = SCNNode(geometry: SCNBox(width: 0.1, height: 4, length: 0.1, chamferRadius: 0))
            let test2 = SCNNode(geometry: SCNBox(width: 0.1, height: 4, length: 0.1, chamferRadius: 0))
            test1.position = point1
            test2.position = point2
            
            node.addChildNode(test1)
            node.addChildNode(test2)
            
            self.addChildNode(node)
            bridges.append(node)
            
            print("Load bridge")
        }
    }
    
}
