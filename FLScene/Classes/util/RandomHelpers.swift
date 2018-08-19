//
//  RandomHelpers.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import Foundation

class RandomHelpers: NSObject {

    class func rand(min:Double,max:Double) -> Double {
        let gap = max - min
        return (drand48() * gap) + min
    }
    
    class func rand(min:Float,max:Float) -> Float {
        let gap = max - min
        return (Float(drand48()) * gap) + min
    }
    
}
