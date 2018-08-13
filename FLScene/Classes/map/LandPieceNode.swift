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
            let model = NodeProvider.instance.tree()
            sitNode(node: model)
        
            //let trail = SCNParticleSystem.flSystem(named: "teleporter")!
            //trail.emitterShape = hexGeometry
            //n1.addParticleSystem(trail)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sitNode(node:SCNNode) {
        let hexMath = Hex3DMath(baseSize: 1)
        self.addChildNode(node)
        let minY = CGFloat(node.boundingBox.min.y)
        
        node.position = SCNVector3(0,hexMath.height()/2 - minY,0) + node.position
        
        /*let constraint = SCNDistanceConstraint(target: self)
        constraint.maximumDistance = 0.1
        node.constraints = [constraint]*/
    }
    
    private func sitGeometry(geometry:SCNGeometry) {
        let node = SCNNode(geometry: geometry)
        sitNode(node: node)
    }
    
}
