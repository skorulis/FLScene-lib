//
//  SceneEditInputHandler.swift
//  Pods
//
//  Created by Alexander Skorulis on 17/8/18.
//

import SceneKit
import SKSwiftLib

public class SceneEditInputHandler {

    let scene:OverlandScene
    
    init(scene:OverlandScene) {
        self.scene = scene
    }
    
    public var editMode:Bool = false {
        didSet {
            selectedNode?.highlighted = false
            selectedNode = nil
            rebuildMap()
        }
    }
    var selectedNode:LandPieceNode?
    
    func rebuildMap() {
        scene.islands.forEach { (island) in
            island.showVoid = self.editMode
        }
        scene.bridges.buildNodes(bridgeModels: scene.overland.bridges, overland: scene)
    }
    
    public func handleTap(square:LandPieceNode) {
        selectedNode?.highlighted = false
        square.highlighted = true
        selectedNode = square
        print("Selected node at position \(square.dungeonNode.gridPosition)" )
        print("Node world position \(square.worldPosition)" )
    }
    
    public func cycleTerrain(backwards:Bool) {
        guard let square = self.selectedNode else { return }
        let type = square.dungeonNode.terrain.type
        let allTerrains:[TerrainType] = ReferenceController.instance.terrain.map { $0.1.type }
        let nextType = backwards ? allTerrains.next(current:type) : allTerrains.prev(current:type)
        square.dungeonNode.terrain = ReferenceController.instance.getTerrain(type: nextType)
        square.rebuildTerrainGeometry()
        print("change terrain \(nextType)")
    }
    
    public func moveTerrain(amount:Int) {
        guard let square = self.selectedNode else { return }
        square.dungeonNode.yOffset += amount
        
        let pos = square.containingMap().localPosition(at: square.dungeonNode.gridPosition)
        square.position = pos
    }
    
}
