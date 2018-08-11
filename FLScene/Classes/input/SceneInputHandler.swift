//
//  SceneInputHandler.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/8/18.
//

import SceneKit

public protocol SceneInputHandlerDelegate: class {
    
    func showLandOptions(node:GKHexMapNode,actions:[DungeonAction])
    
}

public class SceneInputHandler {

    let sceneView:SCNView
    let scene:Map3DScene
    let camera:SCNCamera
    let game = GameController.instance
    public weak var delegate:SceneInputHandlerDelegate?
    
    public init(sceneView:SCNView,scene:Map3DScene,cameraNode:SCNNode) {
        self.sceneView = sceneView
        self.scene = scene;
        self.camera = cameraNode.camera!
        
        let target = self.scene.playerSprite.sprite
        
        let lookAt = SCNLookAtConstraint(target: target)
        lookAt.isGimbalLockEnabled = true
        let distance = SCNDistanceConstraint(target: self.scene.playerSprite.sprite)
        let acceleration = SCNAccelerationConstraint()
        distance.minimumDistance = 12
        distance.maximumDistance = 18
        cameraNode.constraints = [lookAt,distance,acceleration]
    }
    
    public func tapped(point:CGPoint) {
        let options:[SCNHitTestOption : Any] = [SCNHitTestOption.rootNode:scene.playerIsland]
        
        let hits = self.sceneView.hitTest(point, options: options)
        guard let first = hits.first else { return }
        guard let square = first.node.parent as? LandPieceNode else { return }
        
        let fromPoint = scene.playerSprite.gridEntity().gridPosition
        
        let path = scene.playerIsland.dungeon.path(to: square.dungeonNode.gridPosition, from: fromPoint)
        if path.count < 2 {
            return
        }
        
        let firstPoint = path[1]
        self.scene.playerSprite.moveTo(position: firstPoint.gridPosition, inDungeon: scene.overland.playerDungeon!)
    }
    
    public func longPress(point:CGPoint) {
        let options:[SCNHitTestOption : Any] = [SCNHitTestOption.rootNode:scene.playerIsland]
        
        let hits = self.sceneView.hitTest(point, options: options)
        guard let first = hits.first else { return }
        guard let square = first.node.parent as? LandPieceNode else { return }
        
        let node = square.dungeonNode
        
        if let fixture = node.fixture {
            self.delegate?.showLandOptions(node: square.dungeonNode,actions: fixture.ref.actions)
        }
    }
    
    public func performAction(node:GKHexMapNode,action:DungeonAction) {
        if action == .teleport {
            let teleporter = node.fixture as! TeleporterFixtureModel
            let dungeon = teleporter.otherDungeon!
            let node = teleporter.otherNode!
            self.scene.teleportPlayer(dungeon: dungeon, node: node)
        }
    }
    
}
