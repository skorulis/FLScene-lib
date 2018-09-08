//
//  DungeonTileReferenceModel.swift
//  floatios
//
//  Created by Alexander Skorulis on 21/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import Foundation

public enum DungeonTileType:String {
    case wall = "wall"
    case stairsUp = "stair-up"
    case stairsDown = "stair-down"
    case teleporter
    case arena
    case house
}

public struct DungeonTileReferenceModel {

    public let type:DungeonTileType
    public let canPass:Bool
    public let actions:[ActionType]
    
    public init(type:DungeonTileType,canPass:Bool,actions:[ActionType] = []) {
        self.type = type
        self.canPass = canPass
        self.actions = actions
    }
    
}
