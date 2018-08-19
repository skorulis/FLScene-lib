//
//  FLMapSprite.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/8/18.
//

import SceneKit
import SKSwiftLib

public class FLMapSprite: SCNNode {

    weak var mapScene:MapSceneProtocol?
    
    init(image:UIImage,mapScene:MapSceneProtocol) {
        self.mapScene = mapScene
        let plane = SCNPlane(width: 1, height: 2)
        plane.firstMaterial?.diffuse.contents = image
    
        super.init()
        self.geometry = plane
        
        let physicsGeometry = SCNCylinder(radius: 0.5, height: 2)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        let body = SCNPhysicsBody(type: .static, shape: physicsShape)
        body.collisionBitMask = 1
        body.categoryBitMask = 1
        body.contactTestBitMask = 1
        self.physicsBody = body
        
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = SCNBillboardAxis.Y
        self.constraints = [constraint]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
