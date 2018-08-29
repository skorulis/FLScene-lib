//
//  BridgeNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 28/8/18.
//

import SceneKit

private class BridgeContext {
    
    let stoneRadius:CGFloat = 0.3
    let baseGap:CGFloat = 0.1
    let gap:CGFloat
    let stoneCount:CGFloat
    let point1:SCNVector3
    let point2:SCNVector3
    let dir:SCNVector3
    
    init(from:SCNNode,to:SCNNode) {
        let nodeCentre1 = from.worldPosition + SCNVector3(0,0.5,0)
        let nodeCentre2 = to.worldPosition + SCNVector3(0,0.5,0)
        dir = (nodeCentre2 - nodeCentre1).normalized()
        point1 = nodeCentre1 + dir * 1
        point2 = nodeCentre2 - dir * 1
        
        let distance = CGFloat((point2 - point1).magnitude())
        
        stoneCount = floor(distance / (2*stoneRadius + baseGap))
        self.gap = (distance - (stoneCount*stoneRadius)) / (stoneCount + 1)
    }
    
    func scalarPos(i:Int) -> CGFloat {
        let floatI = CGFloat(i)
        let scalarPos = ((floatI+1) * gap) + ((floatI + 0.5) * stoneRadius)
        return scalarPos
    }
    
    func stonePosition(i:Int) -> SCNVector3 {
        let scalar = scalarPos(i: i)
        return point1 + (dir * Float(scalar))
    }
}

class BridgeNode: SCNNode {

    let fromNode:SCNNode
    let toNode:SCNNode
    
    var stones:[SCNNode] = []
    
    init(from:SCNNode,to:SCNNode) {
        self.fromNode = from
        self.toNode = to
        super.init()
        
        createBridgeNodes()
    }
    
    func createBridgeNodes() {
        let context = BridgeContext(from: fromNode, to: toNode)
        self.position = (context.point1 + context.point2)/2
        
        for i in 0..<Int(context.stoneCount) {
            let stone = SCNCylinder(radius: context.stoneRadius, height: 0.1)
            stone.firstMaterial = MaterialProvider.bridgeStoneMaterial()
            let stoneNode = SCNNode(geometry: stone)
            stoneNode.position = context.stonePosition(i: i) - self.position
            
            addChildNode(stoneNode)
            stones.append(stoneNode)
        }
    }
    
    func updateStones() {
        let context = BridgeContext(from: fromNode, to: toNode)
        for i in 0..<self.stones.count {
            let stone = self.stones[i]
            stone.position = context.stonePosition(i: i) - self.position
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
