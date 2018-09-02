//
//  ArenaBattleModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 2/9/18.
//

import GameplayKit

public class ArenaBattleModel: Codable {

    var mapName:String = "" //The map that the battle will take place in
    public var enemies:[ArenaEnemyModel] = [] //Enemies that will be in the map
    public var playerStartPosition:vector_int2 = vector_int2(0,2)
    var waves:Int = 1 //How many waves there are
    var waveDelay:Int = 5 //Seconds between waves starting
    
    public init() {
    
    }
    
    func enemies(for wave:Int) -> [ArenaEnemyModel] {
        return enemies.filter { $0.wave == wave}
    }
    
}

public class FullArenaModel: Codable {
    
    public let battles:[ArenaBattleModel]
    
}
