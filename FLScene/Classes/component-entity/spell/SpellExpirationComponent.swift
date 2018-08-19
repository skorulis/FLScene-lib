//
//  SpellExpirationComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellExpirationComponent: GKComponent {

    var hitTarget:Bool = false
    var lastPoint:SCNVector3?
    var distanceTraveled:Float = 0
    
    func spellEntity() -> SpellEntity {
        return self.entity as! SpellEntity
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let point = spellEntity().node().presentation.worldPosition
        if let oldPoint = lastPoint {
            distanceTraveled += (oldPoint - point).magnitude()
        }
        lastPoint = point
    }
    
    func hasExpired() -> Bool {
        return hitTarget || distanceTraveled > spellEntity().model.range()
    }
    
}
