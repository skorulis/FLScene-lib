//
//  SpellExpirationComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellExpirationComponent: SpellComponent {

    var hitTarget:Bool = false
    var lastPoint:SCNVector3?
    var distanceTraveled:Float = 0
    var age:TimeInterval = 0
    
    
    override func update(deltaTime seconds: TimeInterval) {
        age += seconds
        let point = spellEntity().node().presentation.worldPosition
        if let oldPoint = lastPoint {
            distanceTraveled += (oldPoint - point).magnitude()
        }
        lastPoint = point
    }
    
    func hasExpired() -> Bool {
        if spellModel().type == .totem {
            return self.age > spellModel().maxAge()
        }
        return hitTarget || distanceTraveled > spellModel().range()
    }
    
}
