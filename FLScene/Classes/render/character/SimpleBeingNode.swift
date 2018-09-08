//
//  SimpleBeingNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/9/18.
//

import SceneKit
import SKSwiftLib

class SimpleBeingNode: SCNNode {

    private let radius:CGFloat = 0.35
    private let height:CGFloat = 1.5
    
    init(face:String) {
        
        let sphereRadius = radius * 0.4
        let capsuleHeight = height / 2.5
        let head = SCNSphere(radius: sphereRadius)
        
        let foot = SCNBox(width: radius/2, height: radius/2, length: radius, chamferRadius: 0.05)
        let hand = SCNBox(width: radius/4, height: radius/2, length: radius/1.5, chamferRadius: 0.05)
        
        let body = SCNCapsule(capRadius: radius * 0.5, height: capsuleHeight)
        body.firstMaterial = MaterialProvider.playerBodyMaterial(color: UIColor.orange)
        
        foot.firstMaterial = MaterialProvider.playerBodyMaterial(color: UIColor.purple)
        hand.firstMaterial = MaterialProvider.playerBodyMaterial(color: UIColor.blue)
        head.firstMaterial = MaterialProvider.playerFaceMaterial(glyph: face)
        
        let headNode = SCNNode(geometry: head)
        let bodyNode = SCNNode(geometry: body)
        let leftFootNode = SCNNode(geometry: foot)
        let rightFootNode = SCNNode(geometry: foot)
        let leftHandNode = SCNNode(geometry: hand)
        let rightHandNode = SCNNode(geometry: hand)
        
        let headY = capsuleHeight/2 + sphereRadius + height / 20
        headNode.position = SCNVector3(0,headY,0)
        
        let footOffset = radius * 0.5
        let footY = -height / 3
        
        leftFootNode.position = SCNVector3(-footOffset, footY, 0.1)
        rightFootNode.position = SCNVector3(footOffset, footY, 0.1)
        
        leftHandNode.position = SCNVector3(footOffset, 0, 0.1)
        rightHandNode.position = SCNVector3(-footOffset, 0, 0.1)
        
        super.init()
        
        self.addChildNode(headNode)
        self.addChildNode(bodyNode)
        self.addChildNode(leftFootNode)
        self.addChildNode(rightFootNode)
        self.addChildNode(leftHandNode)
        self.addChildNode(rightHandNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
