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
        scene.spellManager.update(deltaTime: timeSincePreviousUpdate)
        previousUpdateTime = time
    }
    
    public func physicsWorld(_ world: SCNPhysicsWorld,didBegin contact: SCNPhysicsContact) {
        if contact.nodeA.entity != nil || contact.nodeB.entity != nil {
            scene.spellManager.handleContact(contact: contact)
        }
    }
    
    public func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        print("Contact update")
    }
}
