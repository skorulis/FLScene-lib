//
//  SceneInputHandler.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/8/18.
//

import SceneKit
import GameplayKit

public protocol SceneInputHandlerDelegate: class {
    
    func showLandOptions(node:MapHexModel,actions:[DungeonAction])
    
}

public class SceneInputHandler {

    public let sceneView:SCNView
    let scene:Map3DScene
    let camera:SCNCamera
    let game = GameController.instance
    public let editHandler:SceneEditInputHandler
    
    public weak var delegate:SceneInputHandlerDelegate?
    
    
    public init(sceneView:SCNView,scene:Map3DScene,cameraNode:SCNNode) {
        self.sceneView = sceneView
        self.scene = scene;
        self.camera = cameraNode.camera!
        self.editHandler = SceneEditInputHandler()
        
        let target = self.scene.playerEntity.component(ofType: GKSCNNodeComponent.self)!.node
        
        let lookAt = SCNLookAtConstraint(target: target)
        lookAt.isGimbalLockEnabled = true
        let distance = SCNDistanceConstraint(target: target)
        let acceleration = SCNAccelerationConstraint()
        distance.minimumDistance = 12
        distance.maximumDistance = 18
        cameraNode.constraints = [lookAt,distance,acceleration]
    }
    
    public func tapped(point:CGPoint) {
        let options:[SCNHitTestOption : Any] = [SCNHitTestOption.rootNode:scene.playerIslandNode]
        
        let hits = self.sceneView.hitTest(point, options: options)
        guard let first = hits.first else { return }
        guard let square = first.node.parent as? LandPieceNode else { return }
        
        if editHandler.editMode {
            self.editHandler.handleTap(square: square)
            return
        }
        
        let fromPoint = scene.playerEntity.gridPosition
        let path = scene.playerIsland.path(to: square.dungeonNode.gridPosition, from: fromPoint)
        if path.count < 2 {
            return
        }
        
        let firstPoint = path[1]
        let sprite = scene.playerEntity.component(ofType: MovementComponent.self)!
        sprite.moveTo(position: firstPoint.gridPosition, inDungeon: scene.playerIsland)
    }
    
    public func longPress(point:CGPoint) {
        let options:[SCNHitTestOption : Any] = [SCNHitTestOption.rootNode:scene.playerIslandNode]
        
        let hits = self.sceneView.hitTest(point, options: options)
        guard let first = hits.first else { return }
        guard let square = first.node.parent as? LandPieceNode else { return }
        
        let node = square.dungeonNode
        
        if let fixture = node.fixture {
            self.delegate?.showLandOptions(node: square.dungeonNode,actions: fixture.ref.actions)
        }
    }
    
    public func performAction(node:MapHexModel,action:DungeonAction) {
        if action == .teleport {
            let teleporter = node.fixture as! TeleporterFixtureModel
            let dungeon = scene.overland.findIsland(name: teleporter.targetIslandName)
            let node = dungeon.nodeAt(vec: teleporter.targetPosition)!
            
            self.scene.teleportPlayer(dungeon: dungeon, node: node)
        }
    }
    
    
}
