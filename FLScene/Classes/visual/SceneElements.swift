//
//  SceneElements.swift
//  Pods
//
//  Created by Alexander Skorulis on 18/8/18.
//

import SceneKit
import SKSwiftLib

class SceneElements {

    class func ambientLight() -> SCNLight {
        let light = SCNLight()
        light.type = .ambient
        light.temperature = 6500
        light.intensity = 1000
        return light
    }
    
    class func skyBox() -> MDLSkyCubeTexture {
        let skyBox = MDLSkyCubeTexture(name: nil, channelEncoding: MDLTextureChannelEncoding.uInt8,
                                       textureDimensions: [Int32(160), Int32(160)], turbidity: 0.4, sunElevation: 0.7, upperAtmosphereScattering: 0.2, groundAlbedo: 2)
        skyBox.groundColor = UIColor.brown.cgColor
        
        return skyBox
    }
    
}
