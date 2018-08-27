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
        case bridges
    }
    
    public var dungeons:[DungeonModel] = []
    public var player:PlayerCharacterModel?
    var bridges:[BridgeModel] = []
    
    public init(player:PlayerCharacterModel) {
        self.player = player
    }
    
    public func changeEntityIsland(entity:GridEntity,islandName:String,position:vector_int2) {
        if let oldIslandName = entity.islandName {
            let oldIsland = findIsland(name: oldIslandName)
            oldIsland.removeBeing(entity: entity)
        }
        
        entity.islandName = islandName
        entity.gridPosition = position
        
        let island = findIsland(name: islandName)
        island.nodeAt(vec: position)?.beings.append(entity)
    }
    
    public func replaceIsland(island:DungeonModel) {
        for i in 0..<self.dungeons.count {
            if dungeons[i].name == island.name {
                dungeons[i] = island
            }
        }
    }
    
    public func findIsland(name:String) -> DungeonModel {
        return self.dungeons.filter { $0.name == name}.first!
    }

}
