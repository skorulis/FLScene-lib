//
//  PlayerCharacterModel.swift
//  floatios
//
//  Created by Alexander Skorulis on 29/6/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import Foundation

public class PlayerStatsModel {
    
    //How many times the player has performed each action
    public var actionTimeStats:[String:Int] = [:]
    
    public func didPerformAction(action:ActionType) {
        let count = actionTimeStats[action.rawValue] ?? 0
        actionTimeStats[action.rawValue] = count + 1
    }
    
}

public class PlayerCharacterModel {

    public let base:CharacterModel
    public let stats:PlayerStatsModel
    public var journal:[JournalEntry]
    
    init() {
        base = CharacterModel()
        stats = PlayerStatsModel()
        journal = []
    }
    
}
