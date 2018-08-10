//
//  Hex3DMath.swift
//  floatios
//
//  Created by Alexander Skorulis on 3/8/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SceneKit

public class Hex3DMath: NSObject {

    public let baseSize:CGFloat
    
    public init(baseSize:CGFloat) {
        self.baseSize = baseSize
    }
    
    public func regularHexPoint(index:Int) -> CGPoint {
        let angle = (CGFloat(index) * CGFloat.pi / 3) - CGFloat.pi/2
        return CGPoint(angle: angle, length: baseSize)
    }
    
    public func regularHexUV(index:Int) -> CGPoint {
        var point = regularHexPoint(index: index)
        point.x = (point.x + baseSize) / 2;
        point.y = (point.y + baseSize) / 2;
        return point
    }
    
    public func height() -> CGFloat {
        let p1 = regularHexPoint(index: 0)
        let p2 = regularHexPoint(index: 1)
        let v1 = SCNVector3(p1.x,0,p1.y)
        let v2 = SCNVector3(p2.x,0,p2.y)
        return CGFloat((v2 - v1).magnitude())
    }
    
}
