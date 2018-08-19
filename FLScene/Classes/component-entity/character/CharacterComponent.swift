//
//  CharacterComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class CharacterComponent: GKComponent {

    private let health:MaxValueField = MaxValueField(maxValue: 20)
    
    var healthPct:CGFloat {
        return health.fullPercentage
    }
    
    func takeDamage(damage:Int) {
        self.health -= damage
        let sprite = self.entity?.component(ofType: FLSpriteComponent.self)
        sprite?.sprite.updateHealthBar(pct:self.health.fullPercentage)
    }
    
}
