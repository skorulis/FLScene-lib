//
//  IslandMetadataModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 13/8/18.
//

import SceneKit

public class OverlandMetadataModel: Codable {
    
    let islands:[IslandMetadataModel]
    
    init(islands:[IslandMetadataModel]) {
        self.islands = islands
    }
    
}

public class IslandMetadataModel: Codable {

    public let name:String
    let width:Int
    let depth:Int
    let worldOffsetX:CGFloat
    let worldOffsetY:CGFloat
    let worldOffsetZ:CGFloat
    
    func worldOffset() -> SCNVector3 {
        return SCNVector3(worldOffsetX,worldOffsetY,worldOffsetZ)
    }
    
    init(name:String,width:Int,depth:Int,offset:SCNVector3) {
        self.name = name
        self.width = width
        self.depth = depth
        self.worldOffsetX = CGFloat(offset.x)
        self.worldOffsetY = CGFloat(offset.y)
        self.worldOffsetZ = CGFloat(offset.z)
    }
    
}

public class IslandNetworkModel: IslandMetadataModel {
    
    var squares:[IslandSquareModel] = []
    
    
    func meta() -> IslandMetadataModel {
        return IslandMetadataModel(name: name, width: width, depth: depth, offset: worldOffset())
    }
}

public class IslandSquareModel: Codable {
    
    let x:Int
    let y:Int
    let terrain:TerrainType
    
    init(x:Int,y:Int,terrain:TerrainType) {
        self.x = x
        self.y = y
        self.terrain = terrain
    }
    
}