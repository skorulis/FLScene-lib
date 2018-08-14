//
//  TeleporterFixtureModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/8/18.
//

class TeleporterFixtureModel: MapFixtureModel {

    weak var otherDungeon:DungeonModel?
    weak var otherNode:GKHexMapNode?
    
    init(ref:DungeonTileReferenceModel,dungeon:DungeonModel,node:GKHexMapNode) {
        self.otherDungeon = dungeon
        self.otherNode = node
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
