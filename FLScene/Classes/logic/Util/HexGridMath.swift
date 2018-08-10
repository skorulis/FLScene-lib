//
//  HexGridMath.swift
//  floatios
//
//  Created by Alexander Skorulis on 28/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import GameplayKit

public class HexGridMath {
    
    let tileSize:CGSize
    
    public var centre:CGPoint {
        return CGPoint(x: tileSize.width/2, y: tileSize.height/2)
    }
    public var right:CGPoint {
        return CGPoint(x: tileSize.width, y: tileSize.height/2)
    }
    public var left:CGPoint {
        return CGPoint(x: 0, y: tileSize.height/2)
    }
    public var top:CGPoint {
        return CGPoint(x: tileSize.width/2, y: 0)
    }
    public var bottom:CGPoint {
        return CGPoint(x: tileSize.width/2, y: tileSize.height)
    }
    public var topLeft:CGPoint {
        return CGPoint(x: 0, y: tileSize.height/4)
    }
    public var topRight:CGPoint {
        return CGPoint(x: tileSize.width, y: tileSize.height/4)
    }
    public var bottomLeft:CGPoint {
        return CGPoint(x: 0, y: tileSize.height*0.75)
    }
    public var bottomRight:CGPoint {
        return CGPoint(x: tileSize.width, y: tileSize.height*0.75)
    }
    
    public init(tileSize:CGSize) {
        self.tileSize = tileSize
        
    }
    
}

public extension vector_int2 {
    public var hexOddRow:Bool {
        return y % 2 == 1
    }
    
    public var hexLeft:vector_int2 {
        return vector_int2(x-1,y)
    }
    public var hexRight:vector_int2 {
        return vector_int2(x+1,y)
    }
    public var hexBottomRight:vector_int2 {
        return hexOddRow ? vector_int2(x + 1, y + 1) : vector_int2(x, y + 1)
    }
    public var hexBottomLeft:vector_int2 {
        return hexOddRow ? vector_int2(x, y + 1) : vector_int2(x - 1, y + 1)
    }
    public var hexTopRight:vector_int2 {
        return hexOddRow ? vector_int2(x + 1, y - 1) : vector_int2(x, y - 1)
    }
    public var hexTopLeft:vector_int2 {
        return hexOddRow ? vector_int2(x, y - 1) : vector_int2(x - 1, y - 1)
    }
    
    public var hexSurrounding:[vector_int2] {
        return [hexLeft,hexRight,hexBottomLeft,hexBottomRight,hexTopRight,hexTopLeft]
    }
}
