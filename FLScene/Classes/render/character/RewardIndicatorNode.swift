//
//  RewardIndicatorNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/9/18.
//

import SceneKit

class RewardIndicatorNode: SCNNode {

    override init() {
        super.init()
        //Probably want to switch to a box instead at some point, makes it feel more solid
        //let geom = SCNPlane(width: 1, height: 1)
        let geom = SCNBox(width: 1, height: 1, length: 0.1, chamferRadius: 0.1)
        geom.firstMaterial = MaterialProvider.bridgeStoneMaterial()
        self.geometry = geom
        
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = SCNBillboardAxis.Y
        self.constraints = [constraint]

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
