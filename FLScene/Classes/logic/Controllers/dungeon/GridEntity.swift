//
//  GridEntity.swift
//  floatios
//
//  Created by Alexander Skorulis on 25/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import GameplayKit

public class GridEntity: GKEntity {

    public var gridPosition:vector_int2 = vector_int2(x: 0, y: 0)
    public let entityId:String
    public var islandName:String?
    
    override init() {
        entityId = UUID().uuidString
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
    
}
