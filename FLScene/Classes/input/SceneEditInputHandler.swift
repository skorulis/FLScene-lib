//
//  SceneEditInputHandler.swift
//  Pods
//
//  Created by Alexander Skorulis on 17/8/18.
//

import SceneKit
import SKSwiftLib

public class SceneEditInputHandler {

    public var editMode:Bool = false {
        didSet {
            selectedNode?.highlighted = false
            selectedNode = nil
        }
    }
    var selectedNode:LandPieceNode?
    
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
        var allTerrains:[TerrainType] = ReferenceController.instance.terrain.map { $0.1.type }
        allTerrains = allTerrains.filter { $0 != TerrainType.void }
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
