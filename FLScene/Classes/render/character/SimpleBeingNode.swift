//
//  SimpleBeingNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/9/18.
//

import SceneKit
import SKSwiftLib

enum SimpleBeingFootPosition {
    case standard
    case sitting
}

enum SimpleBeingHandPosition {
    case standard
    case fishing
}

class SimpleBeingNode: SCNNode {

    private let radius:CGFloat = 0.35
    private let height:CGFloat = 1.5
    
    private var footPosition:SimpleBeingFootPosition = .standard
    private var handPosition:SimpleBeingHandPosition = .standard
    
    private let leftFootNode:SCNNode
    private let rightFootNode:SCNNode
    
    private let leftHandNode:SCNNode
    private let rightHandNode:SCNNode
    
    init(face:String) {
        let sphereRadius = radius * 0.4
        let capsuleHeight = height / 2.5
        let head = SCNSphere(radius: sphereRadius)
        
        let foot = SCNBox(width: radius/2, height: radius/4, length: radius/1.5, chamferRadius: 0.05)
        let hand = SCNBox(width: radius/4, height: radius/2, length: radius/2, chamferRadius: 0.05)
        
        let body = SCNCapsule(capRadius: radius * 0.5, height: capsuleHeight)
        body.firstMaterial = MaterialProvider.playerBodyMaterial(color: UIColor.orange)
        
        foot.firstMaterial = MaterialProvider.playerBodyMaterial(color: UIColor.purple)
        hand.firstMaterial = MaterialProvider.playerBodyMaterial(color: UIColor.blue)
        head.firstMaterial = MaterialProvider.playerFaceMaterial(glyph: face)
        
        let headNode = SCNNode(geometry: head)
        let bodyNode = SCNNode(geometry: body)
        leftFootNode = SCNNode(geometry: foot)
        rightFootNode = SCNNode(geometry: foot)
        leftHandNode = SCNNode(geometry: hand)
        rightHandNode = SCNNode(geometry: hand)
        
        let headY = capsuleHeight/2 + sphereRadius + height / 20
        headNode.position = SCNVector3(0,headY,0)
        
        super.init()
        
        self.addChildNode(headNode)
        self.addChildNode(bodyNode)
        self.addChildNode(leftFootNode)
        self.addChildNode(rightFootNode)
        self.addChildNode(leftHandNode)
        self.addChildNode(rightHandNode)
        
        let physicsGeometry = SCNCylinder(radius: radius, height: height)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        physicsBody?.collisionBitMask = 1
        physicsBody?.categoryBitMask = 1
        physicsBody?.contactTestBitMask = 1
        
        updateFootPosition(position: .sitting)
        updateHandPosition(position: .standard)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFootPosition(position:SimpleBeingFootPosition) {
        footPosition = position
        
        if position == .standard {
            let footOffset = radius * 0.5
            let footY = -height / 3
            
            leftFootNode.position = SCNVector3(-footOffset, footY, 0.1)
            rightFootNode.position = SCNVector3(footOffset, footY, 0.1)
        } else if position == .sitting {
            let footOffset = radius * 0.5
            let footY:CGFloat = -0.2
            let footZ:CGFloat = radius/1.5
            
            leftFootNode.position = SCNVector3(-footOffset, footY, footZ)
            rightFootNode.position = SCNVector3(footOffset, footY, footZ)
            
            leftFootNode.transform.rotate(angle: CGFloat.pi/2, axis: SCNVector3(1,0,0))
            rightFootNode.transform.rotate(angle: CGFloat.pi/2, axis: SCNVector3(1,0,0))
        }
    }
    
    func updateHandPosition(position:SimpleBeingHandPosition) {
        handPosition = position
        
        let footOffset = radius * 0.5
        leftHandNode.position = SCNVector3(footOffset, 0, 0.1)
        rightHandNode.position = SCNVector3(-footOffset, 0, 0.1)
    }
    
    func updateHealthBar(pct:CGFloat) {

    }
    
    func updateManaBar(pct:CGFloat) {
        
    }
    
}
