//
//  UIImage+Textures.swift
//  FLScene
//
//  Created by Alexander Skorulis on 6/8/18.
//

import SKSwiftLib
import SceneKit

public extension SCNParticleSystem {
    
    public class func flSystem(named:String) -> SCNParticleSystem? {
        let system = SCNParticleSystem(named: named, inDirectory: "Frameworks/FLScene.framework")
        system?.particleImage = UIImage.sceneImage(named: "spark")
        return system
    }
    
}

public extension UIImage {
 
    public class func sceneImage(named:String) -> UIImage? {
        let bundle = Bundle(for: Map3DScene.self)
        let path = bundle.path(forResource: named, ofType: "png")!
        return UIImage(contentsOfFile: path)
    }
    
}
