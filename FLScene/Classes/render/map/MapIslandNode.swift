//
//  Hex3DMapNode.swift
//  floatios
//
//  Created by Alexander Skorulis on 2/8/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SceneKit

public class MapIslandNode: SCNNode {

    public let dungeon:DungeonModel
    public let size:vector_int2
    public var terrain:[LandPieceNode] = []
    public let blockHeight:ASFloat
    
    private let gridMult:Float
    public var showVoid:Bool = false {
        didSet {
            rebuildTerrain()
        }
    }
    
    public init(dungeon:DungeonModel,gridSpacing:Float = 0.9) {
        self.dungeon = dungeon
        self.size = dungeon.size
        self.gridMult = gridSpacing
        
        let hexMath = Hex3DMath(baseSize: 1)
        
        blockHeight = ASFloat(hexMath.height())
        
        super.init()
        
        rebuildTerrain()
    }
    
    func rebuildTerrain() {
        terrain.forEach { $0.removeFromParentNode() }
        terrain.removeAll()
        for y in 0..<size.y {
            for x in 0..<size.x {
                let dungeonNode = dungeon.nodeAt(x: Int(x), y: Int(y))!
                if dungeonNode.terrain.type == .void && !showVoid {
                    continue
                }
                
                let parentNode = LandPieceNode(dungeonNode: dungeonNode)
                parentNode.position = localPosition(at: vector_int2(x,y))
                self.addChildNode(parentNode)
                terrain.append(parentNode)
            }
        }
    }
    
    public func centreOffset() -> SCNVector3 {
        let gridPos = self.size/2
        let pos = localPosition(at: gridPos)
        return SCNVector3(pos.x,0,pos.z)
    }
    
    //Return the 3D coordinates of the tile at the grid index
    public func localPosition(at:vector_int2) -> SCNVector3 {
        let dungeonNode = dungeon.nodeAt(vec: at)
        let yMult:Float = 1.75 * gridMult
        let xMult:Float = 2.0 * gridMult
        
        let isOdd = at.y % 2 == 1
        let offsetX:Float = isOdd ? gridMult : 0
        let rowY = Float(at.y) * yMult
        let yPos = Float(dungeonNode?.yOffset ?? 0) * 0.5
        
        return SCNVector3(Float(at.x)*xMult + offsetX,yPos,rowY)
    }
    
    //Returns the coordinates of the top of the tile
    public func topPosition(at:vector_int2) -> SCNVector3 {
        let mid = localPosition(at: at)
        let top = self.node(at: at).topSurfacePosition()
        return SCNVector3(mid.x,mid.y+top,mid.z)
    }
    
    func node(at:vector_int2) -> LandPieceNode {
        return terrain.filter { $0.dungeonNode.gridPosition == at}.first!
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
