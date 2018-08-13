
//
//  GeometryStore.swift
//  floatios
//
//  Created by Alexander Skorulis on 3/8/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SceneKit

public class GeometryStore: NSObject {

    private var geometries:[String:SCNGeometry] = [:]
    private var materials:[String:SCNMaterial] = [:]
    private var scenes:[String:SCNScene] = [:]
    
    public func getGeometry(name:String,block:()->(SCNGeometry)) -> SCNGeometry {
        if let existing = geometries[name] {
            return existing
        }
        let geom = block()
        geometries[name] = geom
        return geom
    }
    
    public func getMaterial(name:String,block:() -> (SCNMaterial)) -> SCNMaterial {
        if let existing = materials[name] {
            return existing
        }
        let mat = block()
        materials[name] = mat
        return mat
    }
    
    public func getScene(name:String) -> SCNScene {
        if let existing = scenes[name] {
            return existing
        }
        let scene = SCNScene(named: name)!
        scenes[name] = scene
        return scene
    }
    
}
