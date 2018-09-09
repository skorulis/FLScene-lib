//
//  FLMapSprite.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/8/18.
//

import SceneKit
import SKSwiftLib

public class FLMapSprite: SCNNode {

    private var healthBar:SCNNode?
    private var manaBar:SCNNode?
    private var infoIcon:SCNNode?
    
    init(image:UIImage,playerNumber:Int) {
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
        
        //updateHealthBar(pct:1)
        //updateManaBar(pct: 1)
        //updateInfoIcon(text: "$")
    }
    
    func updateHealthBar(pct:CGFloat) {
        if healthBar == nil {
            healthBar = SCNNode()
            healthBar?.position = SCNVector3(0,1,0)
            healthBar?.rotation = SCNVector4(0,0,1,CGFloat.pi/2)
            
            self.addChildNode(healthBar!)
        }
        
        let barGeometry = SCNCylinder(radius: 0.1, height: 1 * pct)
        barGeometry.firstMaterial = MaterialProvider.healthBarMaterial()
        healthBar?.geometry = barGeometry
    }
    
    func updateManaBar(pct:CGFloat) {
        if manaBar == nil {
            manaBar = SCNNode()
            manaBar?.position = SCNVector3(0,1.2,0)
            manaBar?.rotation = SCNVector4(0,0,1,CGFloat.pi/2)
            
            self.addChildNode(manaBar!)
        }
        
        let barGeometry = SCNCylinder(radius: 0.1, height: 1 * pct)
        barGeometry.firstMaterial = MaterialProvider.manaBarMaterial()
        manaBar?.geometry = barGeometry
    }
    
    func updateInfoIcon(text:String) {
        infoIcon?.removeFromParentNode()
        
        let geom = SCNText(string: text, extrusionDepth: 2)
        geom.firstMaterial = MaterialProvider.manaBarMaterial()
        infoIcon = SCNNode(geometry: geom)
        infoIcon?.scale = SCNVector3(0.2,0.2,0.2)
        self.addChildNode(infoIcon!)
        self.position(node: infoIcon!, in: (min:SCNVector3(-0.5,0,-0.5),max:SCNVector3(0.5,1,0.5)))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func position(node:SCNNode, in box:(min:SCNVector3,max:SCNVector3)) {
        let space = box.max - box.min
        let size = node.boundingBox.max - node.boundingBox.min
        let scale = space / size
        let minScale = min(scale.x,scale.y,scale.z)
        node.scale = SCNVector3(minScale,minScale,minScale)
        let scaledBox = node.scaledBoundingBox()
        
        let y = 1 - scaledBox.min.y
        let x:CGFloat = CGFloat(-(scaledBox.max.x - scaledBox.min.x)/2)
        let z:CGFloat = 0
        node.position = SCNVector3(x,CGFloat(y),z)
    }
    
}
