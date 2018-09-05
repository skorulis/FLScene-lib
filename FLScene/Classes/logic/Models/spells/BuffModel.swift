//
//  BuffModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 5/9/18.
//

import Foundation

//A temporary buff applied to the player
class BuffModel: Codable {

    let effect:SpellEffectType //Type of buff
    let powerPoints:Int //How much power the buff has
    var remainingTime:TimeInterval //How long until the buff is removed
    
    init(time:TimeInterval,effect:SpellEffectType,power:Int) {
        self.remainingTime = time
        self.effect = effect
        self.powerPoints = power
    }
    
    func update(deltaTime seconds: TimeInterval) {
        remainingTime -= seconds
    }
    
    func isDead() -> Bool {
        return remainingTime <= 0
    }
    
}
