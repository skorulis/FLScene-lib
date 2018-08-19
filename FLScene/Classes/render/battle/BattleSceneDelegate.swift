//
//  BattleSceneDelegate.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import SceneKit

public class BattleSceneDelegate: NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {

    weak var scene:BattleScene!
    var previousUpdateTime: TimeInterval = 0
    
    public init(scene:BattleScene) {
        self.scene = scene
    }
    
    public func renderer(_: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let timeSincePreviousUpdate = time - previousUpdateTime
        previousUpdateTime = time
        if (timeSincePreviousUpdate > 0.1) {
            return //Animation was probably paused
        }
        
        scene.spellManager.update(deltaTime: timeSincePreviousUpdate)
        scene.characterManager.update(deltaTime: timeSincePreviousUpdate)
    }
    
    public func physicsWorld(_ world: SCNPhysicsWorld,didBegin contact: SCNPhysicsContact) {
        if contact.spellNode() != nil {
            scene.spellManager.handleContact(contact: contact)
        }
    }
    
}
