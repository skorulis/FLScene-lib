//
//  OverlandSceneDelegate.swift
//  Pods
//
//  Created by Alexander Skorulis on 28/8/18.
//

import SceneKit

public class OverlandSceneDelegate: NSObject, SCNSceneRendererDelegate {

    weak var scene:OverlandScene!
    var previousUpdateTime: TimeInterval = 0
    
    public init(scene:OverlandScene) {
        self.scene = scene
    }
    
    public func renderer(_: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        previousUpdateTime = time
        scene.bridges.updateBridges()
    }
    
}
