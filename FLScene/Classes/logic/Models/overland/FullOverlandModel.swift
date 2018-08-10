//
//  FullOverlandModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/8/18.
//

public class FullOverlandModel {

    public var dungeons:[DungeonModel] = []
    public var player:PlayerCharacterModel?
    
    public init(player:PlayerCharacterModel) {
        self.player = player
    }
    
    //The dungeon that the player is in
    public var playerDungeon:DungeonModel? {
        return dungeons.first!
    }
}
