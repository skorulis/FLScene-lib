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
}

class BattleManager {

    weak var scene:BattleScene?
    let model:ArenaBattleModel
    var state:BattleManagerState = .preparation
    var remainingDelay:TimeInterval
    var currentWave:Int
    
    init(scene:BattleScene,model:ArenaBattleModel) {
        self.scene = scene
        self.model = model
        remainingDelay = TimeInterval(model.waveDelay)
        currentWave = 0
    }
    
    func update(deltaTime seconds: TimeInterval) {
        if state == .preparation {
            remainingDelay -= seconds
            if (remainingDelay <= 0) {
                nextWave()
            }
        } else if state == .battling {
            
        }
    }
    
    func nextWave() {
        currentWave = currentWave + 1
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
