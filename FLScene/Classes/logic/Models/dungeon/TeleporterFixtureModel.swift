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
    
    init(ref:DungeonTileReferenceModel,dungeon:DungeonModel,node:MapHexModel) {
        self.targetIslandName = dungeon.name
        self.targetPosition = node.gridPosition
        super.init(ref: ref)
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(targetIslandName, forKey: .targetIsland)
        try container.encode(targetPosition, forKey: .targetPosition)
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.targetIslandName = try values.decode(String.self, forKey: .targetIsland)
        self.targetPosition = try values.decode(vector_int2.self, forKey: .targetPosition)
        try super.init(from: decoder)
    }
    
}
