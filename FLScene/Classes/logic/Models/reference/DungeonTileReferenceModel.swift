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
}

public enum DungeonAction: String {
    case goUp
    case goDown
    case examine
    case teleport
    case battle
}

public struct DungeonTileReferenceModel {

    public let type:DungeonTileType
    public let canPass:Bool
    public let actions:[DungeonAction]
    
    public init(type:DungeonTileType,canPass:Bool,actions:[DungeonAction] = []) {
        self.type = type
        self.canPass = canPass
        self.actions = actions
    }
    
}
