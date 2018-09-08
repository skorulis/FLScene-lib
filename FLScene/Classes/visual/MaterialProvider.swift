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

    private static let normalColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 1, alpha: 1)
    
    class func sideMaterial(ref:TerrainReferenceModel) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = ref.baseColor
        
        switch ref.type {
        case .redRock:
            material.diffuse.contents = UIImage.sceneImage(named:"montagne_albedo")
            material.normal.contents = UIImage.sceneImage(named: "montagne_normal")
            material.roughness.contents = UIImage.sceneImage(named:"montagne_roughness")
        case .sand:
            material.diffuse.contents = UIImage.sceneImage(named: "sandyground1_diffuse")
            material.normal.contents = UIImage.sceneImage(named: "sandyground1_normal")
            material.metalness.contents = UIImage.sceneImage(named: "sandyground1_metallic")
            material.locksAmbientWithDiffuse = true
        case .metal:
            material.diffuse.contents = UIImage.sceneImage(named: "rustediron-streaks_diffuse")
            material.normal.contents = UIImage.sceneImage(named: "rustediron-streaks_normal")
            material.metalness.contents = UIImage.sceneImage(named: "rustediron-streaks_metallic")
            material.roughness.contents = UIImage.sceneImage(named: "rustediron-streaks_roughness")
            material.locksAmbientWithDiffuse = true
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
        case .sand:
            let diffuseImage = UIImage.sceneImage(named: "sandyground1_diffuse")!
            material.diffuse.contents = imageGen.topHex(diffuseImage, lineColor: UIColor.black)
            let normalImage = UIImage.sceneImage(named: "sandyground1_normal")!
            material.normal.contents = imageGen.topHex(normalImage, lineColor: normalColor)
            material.roughness.contents = 1
        case .metal:
            material.diffuse.contents = UIImage.sceneImage(named: "rustediron-streaks_diffuse")
            material.normal.contents = UIImage.sceneImage(named: "rustediron-streaks_normal")
            material.metalness.contents = UIImage.sceneImage(named: "rustediron-streaks_metallic")
            material.roughness.contents = UIImage.sceneImage(named: "rustediron-streaks_roughness")
        default:
            material.diffuse.contents = imageGen.topHex(ref.baseColor)
            material.normal.contents = UIImage.sceneImage(named: "scuffed-plastic-normal")
        }
        
        return material
    }
    
    class func bridgeStoneMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage.sceneImage(named: "rustediron-streaks_diffuse")
        material.normal.contents = UIImage.sceneImage(named: "rustediron-streaks_normal")
        material.metalness.contents = UIImage.sceneImage(named: "rustediron-streaks_metallic")
        material.roughness.contents = UIImage.sceneImage(named: "rustediron-streaks_roughness")
        
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
    
    class func playerFaceMaterial(glyph:String) -> SCNMaterial {
        let material = SCNMaterial()
        let faceColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.8, alpha: 1)
        material.diffuse.contents = HexTextureGenerator().face(glyph: glyph, color: faceColor)
        return material
    }
    
    class func playerBodyMaterial(color:UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = color
        material.normal.contents = UIImage.sceneImage(named: "plasticpattern1-normal2b")
        material.roughness.contents = UIImage.sceneImage(named: "plasticpattern1-roughness2")
        return material
    }
    
    class func targetMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(displayP3Red: 1.0, green: 0.2, blue: 0.2, alpha: 1)
        return material
    }
    
    class func healthBarMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        return material
    }
    
    class func manaBarMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        return material
    }
    
    class func pbrMaterial(baseName:String)  {
        
    }
    
}
