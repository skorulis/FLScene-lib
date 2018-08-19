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
    private var healthBar:SCNNode?
    
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
        
        updateHealthBar(pct:1)
    }
    
    func updateHealthBar(pct:CGFloat) {
        healthBar?.removeFromParentNode()
        
        
        
        let healthBarGeometry = SCNCylinder(radius: 0.1, height: 1 * pct)
        healthBarGeometry.firstMaterial = MaterialProvider.healthBarGeometry()
        healthBar = SCNNode(geometry: healthBarGeometry)
        
        healthBar?.position = SCNVector3(0,1,0)
        healthBar?.rotation = SCNVector4(0,0,1,CGFloat.pi/2)
        
        self.addChildNode(healthBar!)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
