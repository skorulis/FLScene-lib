//
//  MaterialProvider.swift
//  FLScene
//
//  Created by Alexander Skorulis on 5/8/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SceneKit
import SKSwiftLib

class MaterialProvider: NSObject {

    class func sideMaterial(ref:TerrainReferenceModel) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = ref.baseColor
        
        switch ref.type {
        case .redRock:
            material.diffuse.contents = UIImage.sceneImage(named:"montagne_albedo")
            material.normal.contents = UIImage.sceneImage(named: "montagne_normal")
            material.roughness.contents = UIImage.sceneImage(named:"montagne_roughness")
        default:
            let imageGen = HexTextureGenerator()
            material.diffuse.contents = imageGen.spikeySide(ref.baseColor)
        }
        
        return material
    }
    
    class func topMaterial(ref:TerrainReferenceModel) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = ref.baseColor
        let imageGen = HexTextureGenerator()
        
        switch ref.type {
        case .redRock:
            material.diffuse.contents = UIImage.sceneImage(named: "montagne_top_albedo")
            material.normal.contents = UIImage.sceneImage(named: "montagne_top_normal")
            material.roughness.contents = UIImage.sceneImage(named: "montagne_top_roughness")
        case .water:
            material.diffuse.contents = imageGen.topHex(ref.baseColor)
            material.normal.contents = UIImage.sceneImage(named: "terrasses_water_normal")
        case .dirt:
            material.diffuse.contents = UIImage.sceneImage(named: "dry-dirt2-albedo")
            material.normal.contents = UIImage.sceneImage(named: "dry-dirt2-normal")
        case .grass:
            material.diffuse.contents = UIImage.sceneImage(named: "mossy-ground1-albedo")
            material.normal.contents = UIImage.sceneImage(named: "mossy-ground1-normal")
            material.roughness.contents = UIImage.sceneImage(named: "mossy-ground1-roughness")
        default:
            material.diffuse.contents = imageGen.topHex(ref.baseColor)
            material.normal.contents = UIImage.sceneImage(named: "scuffed-plastic-normal")
        }
        
        return material
    }
    
    class func floorMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(displayP3Red: 0.4, green: 0.4, blue: 0.6, alpha: 1)
        material.normal.contents = UIImage.sceneImage(named: "terrasses_water_normal")
        material.lightingModel = .physicallyBased
        //material.diffuse.contentsTransform = SCNMatrix4MakeScale(256, 256, 0)
        
        return material
    }
    
}
