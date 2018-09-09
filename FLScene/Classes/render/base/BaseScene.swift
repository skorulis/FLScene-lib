//
//  BaseScene.swift
//  Pods
//
//  Created by Alexander Skorulis on 8/9/18.
//

import SceneKit

public class BaseScene: SCNScene {

    public let cameraNode:SCNNode
    let camera:SCNCamera
    var skybox:SkyboxManager!
    var characterManager:CharacterManager!
    var spellManager:SpellManager?
    var battleManager:BattleManager?
    public let bridges:BridgeContainerNode
    
    override init() {
        cameraNode = SCNNode()
        camera = SCNCamera()
        cameraNode.camera = camera
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 4, z: 15)
        cameraNode.look(at: SCNVector3())
        self.bridges = BridgeContainerNode()
        
        super.init()
        rootNode.addChildNode(cameraNode)
        self.skybox = SkyboxManager(scene: self)
        skybox.updateSkybox()
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SceneElements.ambientLight()
        rootNode.addChildNode(ambientLightNode)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
