//
//  GKHexMapNode.swift
//  floatios
//
//  Created by Alexander Skorulis on 22/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import GameplayKit

public class GKHexMapNode: GKGridGraphNode {

    public var terrain:TerrainReferenceModel
    public var fixture:DungeonTileReferenceModel?
    
    //Things that can move around from node to node, allows for multiple as battles can happen when they are in the same node
    public var beings:[GridEntity] = []
    //var items:[ItemModel]
    
    public var yOffset:Int = 0
    
    public init(terrain:TerrainReferenceModel,position:vector_int2) {
        self.terrain = terrain
        super.init(gridPosition:position)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeAllConnections() {
        self.removeConnections(to: self.connectedNodes, bidirectional: true)
    }
    
    public func canPass() -> Bool {
        if let f = fixture {
            return f.canPass
        }
        return true
    }
    
}
