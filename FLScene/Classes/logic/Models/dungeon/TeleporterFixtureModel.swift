//
//  TeleporterFixtureModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/8/18.
//

import SceneKit

class TeleporterFixtureModel: MapFixtureModel {

    let targetIslandName:String
    let targetPosition:vector_int2
    
    init(ref:DungeonTileReferenceModel,dungeon:DungeonModel,node:GKHexMapNode) {
        self.targetIslandName = dungeon.name
        self.targetPosition = node.gridPosition
        super.init(ref: ref)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        //TODO: Encode dungeon and node -> And think heavily about this as it causes problems
        //var container = encoder.container(keyedBy: CodingKeys.self)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
