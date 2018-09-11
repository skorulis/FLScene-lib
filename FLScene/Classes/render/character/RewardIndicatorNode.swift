//
//  RewardIndicatorNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/9/18.
//

import SceneKit
import SKSwiftLib

class RewardIndicatorNode: SCNNode {

    override init() {
        super.init()
        //Probably want to switch to a box instead at some point, makes it feel more solid
        //let geom = SCNPlane(width: 1, height: 1)
        let geom = SCNBox(width: 1, height: 1, length: 0.1, chamferRadius: 0.05)
        let matFace = MaterialProvider.spriteMaterial(named: "fish")
        let matEdge = MaterialProvider.colorMaterial(color: UIColor.black)
        
        geom.materials = [matFace,matEdge,matFace,matEdge,matEdge,matEdge]
        self.geometry = geom
        
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = SCNBillboardAxis.Y
        //self.constraints = [constraint]

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
