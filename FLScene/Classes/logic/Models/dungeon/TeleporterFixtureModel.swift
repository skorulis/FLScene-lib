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
    
}
