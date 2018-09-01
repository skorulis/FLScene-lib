//
//  LocationModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 1/9/18.
//

import GameplayKit

class LocationModel: Codable {

    public var gridPosition:vector_int2 = vector_int2(x: 0, y: 0)
    public var islandName:String?
    
    init(gridPosition:vector_int2,islandName:String? = nil) {
        self.gridPosition = gridPosition
        self.islandName = islandName
    }
    
    func update(gridPosition:vector_int2,islandName:String? = nil) {
        self.gridPosition = gridPosition
        self.islandName = islandName
    }
    
}
