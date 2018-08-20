//
//  EntityMovementComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 21/8/18.
//

import GameplayKit

class EntityMovementComponent: GKComponent {

    func gridEntity() -> GridEntity {
        return self.entity as! GridEntity
    }
    
    
    
}
