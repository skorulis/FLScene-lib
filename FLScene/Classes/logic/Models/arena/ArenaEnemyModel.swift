//
//  ArenaEnemyModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 2/9/18.
//

import GameplayKit

public class ArenaEnemyModel: Codable {

    public var position:vector_int2 = vector_int2(0,0)
    public var base:CharacterModel = CharacterModel(name: "empty")
    public var ai:BattleAIModel = BattleAIModel()
    
    public init() {
        
    }
    
}
