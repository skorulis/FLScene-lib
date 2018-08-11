//
//  FullOverlandModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/8/18.
//

import GameplayKit

public class FullOverlandModel {

    public var dungeons:[DungeonModel] = []
    public var player:PlayerCharacterModel?
    public var playerDungeon:DungeonModel?
    
    public init(player:PlayerCharacterModel) {
        self.player = player
    }
    
    public func changePlayerDungeon(player:PlayerCharacterModel,dungeon:DungeonModel) {
        self.playerDungeon = dungeon
    }

}
