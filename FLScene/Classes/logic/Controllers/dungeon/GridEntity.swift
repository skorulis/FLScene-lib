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
    
    public var x:Int {
        return Int(gridPosition.x)
    }
    
    public var y:Int {
        return Int(gridPosition.y)
    }
    
}
