//
//  FullOverlandModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/8/18.
//

import GameplayKit

public class FullOverlandModel: Codable {

    enum CodingKeys: String, CodingKey {
        case dungeons = "islands"
    }
    
    public var dungeons:[DungeonModel] = []
    public var player:PlayerCharacterModel?
    public var playerDungeon:DungeonModel?
    
    public init(player:PlayerCharacterModel) {
        self.player = player
    }
    
    public func changePlayerDungeon(player:PlayerCharacterModel,dungeon:DungeonModel,position:vector_int2) {
        playerDungeon?.playerNode = nil //Remove old player node
        dungeon.playerNode = DungeonCharacterEntity(char: player.base)
        dungeon.playerNode?.gridPosition = position
        self.playerDungeon = dungeon
    }
    
    public func replaceIsland(island:DungeonModel) {
        for i in 0..<self.dungeons.count {
            if dungeons[i].name == island.name {
                dungeons[i] = island
            }
        }
    }

}
