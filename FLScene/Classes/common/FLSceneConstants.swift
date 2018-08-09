//
//  FLSceneConstants.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/8/18.
//

import SceneKit

struct NodeCategory: OptionSet {
    let rawValue: Int
    
    static let innerGeometry = NodeCategory(rawValue: 1 << 0)
    static let landSquare = NodeCategory(rawValue: 1 << 1)

    
}
