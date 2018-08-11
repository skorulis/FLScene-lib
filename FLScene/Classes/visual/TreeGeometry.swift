//
//  TreeGeometry.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/8/18.
//

import SceneKit

class TreeGeometry: NSObject {

    func makeTree() -> SCNGeometry {
        return SCNBox(width: 1, height: 0.5, length: 1, chamferRadius: 0)
    }
    
}
