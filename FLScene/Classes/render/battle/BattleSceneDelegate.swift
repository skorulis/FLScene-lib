//
//  BattleSceneDelegate.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import SceneKit

public class BattleSceneDelegate: NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {

    weak var scene:BaseScene!
    var previousUpdateTime: TimeInterval = 0
    
    public init(scene:BaseScene) {
        self.scene = scene
    }
    
    public func renderer(_: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let timeSincePreviousUpdate = time - previousUpdateTime
        previousUpdateTime = time
        if (timeSincePreviousUpdate > 0.1) {
            return //Animation was probably paused
        }
        
        scene.bridges.updateBridges()
        
        scene.spellManager?.update(deltaTime: timeSincePreviousUpdate)
        scene.characterManager.update(deltaTime: timeSincePreviousUpdate)
        scene.battleManager?.update(deltaTime: timeSincePreviousUpdate)
    }
    
    public func physicsWorld(_ world: SCNPhysicsWorld,didBegin contact: SCNPhysicsContact) {
        if contact.spellNode() != nil {
            scene.spellManager?.handleContact(contact: contact)
        }
    }
    
}
