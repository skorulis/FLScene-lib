//
//  BaseCharacterComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/9/18.
//

import GameplayKit

public class BaseEntityComponent: GKComponent {

    func gridEntity() -> GridEntity {
        return self.entity! as! GridEntity
    }
    
    func location() -> LocationModel {
        return gridEntity().location
    }
    
    func events() -> CharacterEventComponent? {
        return self.entity?.component(ofType: CharacterEventComponent.self)
    }
    
    func node() -> SCNNode? {
        return self.entity?.component(ofType: GKSCNNodeComponent.self)?.node
    }
    
    open func wasAddedToManager(manager:CharacterManager) {
        //To be overriden by subclasses
    }
    
}
