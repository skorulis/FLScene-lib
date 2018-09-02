//
//  BattleManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 2/9/18.
//

import Foundation

enum BattleManagerState {
    case battling
    case preparation
    case finished
}

class BattleManager {

    weak var scene:BattleScene?
    let model:ArenaBattleModel
    var state:BattleManagerState = .preparation
    var remainingDelay:TimeInterval = 0
    var currentWave:Int = 0
    
    init(scene:BattleScene,model:ArenaBattleModel) {
        self.scene = scene
        self.model = model
        self.reset()
    }
    
    func update(deltaTime seconds: TimeInterval) {
        if state == .preparation {
            remainingDelay -= seconds
            guard remainingDelay <= 0 else { return }
            if currentWave < model.waves {
                nextWave()
            } else {
                state = .finished
            }
            
        } else if state == .battling {
            let playerCount = scene!.characterManager.playerEntities(playerNumber: 1).count
            let enemyCount = scene!.characterManager.playerEntities(playerNumber: 2).count
            if playerCount == 0 {
                print("player dead ")
                state = .finished
                //Reset battle and get the player to start again
            } else if enemyCount == 0 {
                print("all enemies dead ")
                state = .preparation //Next wave
            }
        } else if state == .finished {
            scene?.resetBattle()
        }
    }
    
    func reset() {
        state = .preparation
        remainingDelay = TimeInterval(model.waveDelay)
        currentWave = 0
    }
    
    func nextWave() {
        state = .battling
        currentWave = currentWave + 1
        print("start wave \(currentWave)")
        remainingDelay = TimeInterval(model.waveDelay)
        let enemies = model.enemies(for: currentWave)
        guard let scene = scene else { return }
        
        for enemy in enemies {
            let entity = scene.makeEntity(character: enemy.base, playerNumber: 2,position:enemy.position)
 entity.addComponent(BattleAIComponent(island:scene.island,spells:scene.spellManager,characterManager:scene.characterManager))
            scene.characterManager.add(entity: entity)
        }
    }
    
}
