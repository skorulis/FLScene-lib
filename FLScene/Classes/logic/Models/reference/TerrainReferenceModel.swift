//
//  TerrainReferenceModel.swift
//  floatios
//
//  Created by Alexander Skorulis on 22/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SKSwiftLib

public enum TerrainType: String, Codable {
    case grass
    case dirt
    case floor
    case water
    case redRock
    case void
}

public struct TerrainReferenceModel:Codable {

    public let type:TerrainType
    public let colorHex:String
    //public let baseColor:UIColor
    
    public var baseColor:UIColor {
        return UIColor(hexString: colorHex)
    }
    
}
