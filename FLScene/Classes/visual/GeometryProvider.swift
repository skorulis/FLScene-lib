//
//  GeometryProvider.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/8/18.
//

import SceneKit

class GeometryProvider {

    static let instance = GeometryProvider()
    
    private let store:GeometryStore
    private let materials:MaterialProvider
    private let hexGeometry:HexGeometry
    
    init() {
        store = GeometryStore()
        materials = MaterialProvider()
        hexGeometry = HexGeometry(store: store)
    }
    
    public func hexGeometry(ref:TerrainReferenceModel) -> SCNGeometry {
        let name = "hex-\(ref.type.rawValue)"
        return store.getGeometry(name: name, block: {return self.hexGeometry.createGeometry(ref: ref)})
    }
    
    public func sideGeometry(height:CGFloat,ref:TerrainReferenceModel) -> SCNGeometry {
        let name = "hex-sides-\(height)-\(ref.type.rawValue)"
        return store.getGeometry(name: name, block: {return self.hexGeometry.createSides(height: height,ref: ref)})
    }
    
    public func bevelHex(ref:TerrainReferenceModel) -> SCNGeometry {
        let name = "hex-bevel-\(ref.type.rawValue)"
        return store.getGeometry(name: name, block: {return self.hexGeometry.createBevelHex(ref:ref)})
    }
    
}
