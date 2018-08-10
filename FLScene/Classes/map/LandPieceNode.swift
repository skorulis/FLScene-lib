//
//  LandPieceNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/8/18.
//

import SceneKit

public class LandPieceNode: SCNNode {

    public let dungeonNode:GKHexMapNode
    
    init(dungeonNode:GKHexMapNode) {
        self.dungeonNode = dungeonNode
        super.init()
        let terrain = dungeonNode.terrain
        let hexMath = Hex3DMath(baseSize: 1)
        let hexGeometry = GeometryProvider.instance.bevelHex(ref:terrain)
        let sides = GeometryProvider.instance.sideGeometry(height:hexMath.height(),ref:terrain)
        let n1 = SCNNode(geometry: hexGeometry)
        let n2 = SCNNode(geometry: sides)
        self.addChildNode(n1)
        self.addChildNode(n2)
        
        if let fixture = dungeonNode.fixture {
            let trail = SCNParticleSystem.flSystem(named: "teleporter")!
            trail.emitterShape = hexGeometry
            
            n1.addParticleSystem(trail)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
