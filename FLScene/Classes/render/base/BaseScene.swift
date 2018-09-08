//
//  BaseScene.swift
//  Pods
//
//  Created by Alexander Skorulis on 8/9/18.
//

import SceneKit

public class BaseScene: SCNScene {

    let cameraNode:SCNNode
    let camera:SCNCamera
    
    override init() {
        cameraNode = SCNNode()
        camera = SCNCamera()
        cameraNode.camera = camera
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 4, z: 15)
        cameraNode.look(at: SCNVector3())
        
        super.init()
        rootNode.addChildNode(cameraNode)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
