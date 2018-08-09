//
//  SceneInputHandler.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/8/18.
//

import SceneKit

public class SceneInputHandler {

    let sceneView:SCNView
    let scene:Map3DScene
    
    public init(sceneView:SCNView,scene:Map3DScene) {
        self.sceneView = sceneView
        self.scene = scene;
    }
    
    public func tapped(point:CGPoint) {
        let options:[SCNHitTestOption : Any] = [SCNHitTestOption.rootNode:scene.mapGrid]
        
        let hits = self.sceneView.hitTest(point, options: options)
        guard let first = hits.first else { return }
        guard let square = first.node.parent as? LandPieceNode else { return }
        
        let fromPoint = scene.playerSprite.gridEntity().gridPosition
        
        let path = scene.mapGrid.dungeon.path(to: square.dungeonNode.gridPosition, from: fromPoint)
        if path.count < 2 {
            return
        }
        
        let firstPoint = path[1]
        self.scene.playerSprite.moveTo(position: firstPoint.gridPosition)
    }
    
}
