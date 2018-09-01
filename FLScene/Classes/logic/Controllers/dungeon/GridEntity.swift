//
//  GridEntity.swift
//  floatios
//
//  Created by Alexander Skorulis on 25/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import GameplayKit

public class GridEntity: GKEntity {

    let location:LocationModel
    
    var gridPosition:vector_int2 {
        return location.gridPosition
    }
    
    var islandName:String? {
        return location.islandName
    }
    
    public let entityId:String
    
    init(location:LocationModel) {
        entityId = UUID().uuidString
        self.location = location
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var x:Int {
        return Int(gridPosition.x)
    }
    
    public var y:Int {
        return Int(gridPosition.y)
    }
    
    public func setTarget(entity:GridEntity,show:Bool = false) {
        if let component = component(ofType: TargetComponent.self) {
            component.target = entity
            component.showTarget = show
        } else {
            let component = TargetComponent(target: entity)
            component.showTarget = show
            self.addComponent(component)
        }
    }
    
    func isBusy() -> Bool {
        if let spriteComponent = component(ofType: MovementComponent.self) {
            if (spriteComponent.isMoving) {
                return true
            }
        }
        if let casting = component(ofType: SpellCastingComponent.self) {
            if casting.isCasting() {
                return true
            }
        }
        return false
    }
    
}
