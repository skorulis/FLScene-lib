//
//  SimpleBeingNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/9/18.
//

import SceneKit
import SKSwiftLib

class SimpleBeingNode: SCNNode {

    private let radius:CGFloat = 0.5
    private let height:CGFloat = 2
    
    init(face:String) {
        
        let coneHeight = height / 2
        let sphereRadius = radius * 0.6
        let cone = SCNCone(topRadius: radius * 0.5, bottomRadius: radius, height: coneHeight)
        let head = SCNSphere(radius: sphereRadius)
        
        cone.firstMaterial = MaterialProvider.playerBodyMaterial(color: UIColor.orange)
        head.firstMaterial = MaterialProvider.playerFaceMaterial(glyph: face)
        
        let coneNode = SCNNode(geometry: cone)
        let headNode = SCNNode(geometry: head)
        
        let headY = coneNode.position.y + coneHeight/2 + sphereRadius + 0.1
        
        headNode.position = SCNVector3(0,headY,0)
        
        super.init()
        
        self.addChildNode(coneNode)
        self.addChildNode(headNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
