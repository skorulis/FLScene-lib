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
        let bundle = Bundle(for: Map3DScene.self)
        let path = bundle.path(forResource: named, ofType: "scnp")!
        do {
            let data = try Data(contentsOf: URL.init(fileURLWithPath: path))
            //TODO: Work out what's wrong with this, or just make it in code?
            let coder = NSKeyedUnarchiver(forReadingWith: data)
            return SCNParticleSystem(coder: coder)
        } catch {
            print("Error reading particle system \(error)")
        }
        return nil;
    }
    
}

public extension UIImage {
 
    public class func sceneImage(named:String) -> UIImage? {
        let bundle = Bundle(for: Map3DScene.self)
        let path = bundle.path(forResource: named, ofType: "png")!
        return UIImage(contentsOfFile: path)
    }
    
}
