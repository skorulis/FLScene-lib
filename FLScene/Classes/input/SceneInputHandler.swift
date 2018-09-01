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
    let scene:OverlandScene
    let camera:SCNCamera
    let game = GameController.instance
    public let editHandler:SceneEditInputHandler
    
    public weak var delegate:SceneInputHandlerDelegate?
    
    
    public init(sceneView:SCNView,scene:OverlandScene,cameraNode:SCNNode) {
        self.sceneView = sceneView
        self.scene = scene;
        self.camera = cameraNode.camera!
        self.editHandler = SceneEditInputHandler(scene:scene)
        
        let target = self.scene.playerEntity.component(ofType: GKSCNNodeComponent.self)!.node
        
        let lookAt = SCNLookAtConstraint(target: target)
        lookAt.isGimbalLockEnabled = true
        let distance = SCNDistanceConstraint(target: target)
        let acceleration = SCNAccelerationConstraint()
        distance.minimumDistance = 10
        distance.maximumDistance = 14
        cameraNode.constraints = [lookAt,distance,acceleration]
    }
    
    public func tapped(point:CGPoint) {
        let options:[SCNHitTestOption : Any] = [SCNHitTestOption.rootNode:scene.playerIslandNode]
        
        let hits = self.sceneView.hitTest(point, options: options)
        if hits.count > 0 {
            tappedCurrentIsland(hit: hits[0])
            return
        }
        
        let bridgeOptions:[SCNHitTestOption: Any]  = [SCNHitTestOption.rootNode:scene.bridges]
        let bridgeHits = self.sceneView.hitTest(point, options: bridgeOptions)
        if bridgeHits.count > 0 {
            tappedBridge(hit: bridgeHits[0])
            return
        }
        
    }
    
    private func tappedBridge(hit:SCNHitTestResult) {
        guard let bridgeNode = hit.node.parent as? BridgeNode else { return }
        
        let playerStartBridgePosition = bridgeNode.model.position(for: scene.playerIsland.name)!
        
        //let island1 = scene.island(named: bridgeNode.model.firstIslandName)
        //let island2 = scene.island(named: bridgeNode.model.secondIslandName)
        
        let fromPoint = scene.playerEntity.gridPosition
        let path = scene.playerIsland.path(to: playerStartBridgePosition, from: fromPoint)
        let pathSteps = getTileSteps(path: path) + getBridgeSteps(bridge: bridgeNode)
        
        let movement = scene.playerEntity.component(ofType: MovementComponent.self)!
        if movement.isMoving {
            return //Can't move twice
        }
        movement.moveAlong(steps: pathSteps)
    }
    
    private func tappedCurrentIsland(hit:SCNHitTestResult) {
        guard let square = hit.node.parent as? LandPieceNode else { return }
        
        if editHandler.editMode {
            self.editHandler.handleTap(square: square)
            return
        }
        
        let fromPoint = scene.playerEntity.gridPosition
        let path = scene.playerIsland.path(to: square.dungeonNode.gridPosition, from: fromPoint)
        let pathSteps = getTileSteps(path: path)
        let movement = scene.playerEntity.component(ofType: MovementComponent.self)!
        if movement.isMoving {
            return //Can't move twice
        }
        movement.moveAlong(steps: pathSteps)
    }
    
    private func getTileSteps(path:[MapHexModel]) -> [MovementStep] {
        if path.count < 2 {
            return []
        }
        
        let completePath = Array(path.suffix(from: 1))
        let pathSteps = completePath.map { (model) -> MovementStep in
            let step = TileStep(position: model.gridPosition, dungeon: scene.playerIsland)
            return MovementStep.tile(step)
        }
        return pathSteps
    }
    
    private func getBridgeSteps(bridge:BridgeNode) -> [MovementStep] {
        let forwards = bridge.model.isFirst(island: scene.playerIsland.name)
        var steps:[MovementStep] = []
        for i in 0..<bridge.stones.count {
            let stoneIndex = forwards ? i : bridge.stones.count - i - 1
            let step = BridgeStep(stoneIndex: stoneIndex, model: bridge.model)
            steps.append(MovementStep.bridge(step))
        }
        let lastIslandName = bridge.model.otherEnd(island: scene.playerIsland.name)
        let lastIslandPosition = bridge.model.position(for: lastIslandName)!
        let tileStep = TileStep(position: lastIslandPosition, dungeon: scene.island(named: lastIslandName))
        steps.append(MovementStep.tile(tileStep))
        
        return steps
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
        } else if action == .sleep {
            self.scene.skybox.animateToTime(time: 1)
        }
    }
    
    
}
