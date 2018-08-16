//
//  UIImage+Textures.swift
//  FLScene
//
//  Created by Alexander Skorulis on 6/8/18.
//

import SKSwiftLib
import SceneKit

public extension SCNNode {
    
    public convenience init(named name: String) {
        self.init()
        
        guard let scene = SCNScene(named: name) else {
            return
        }
        
        for childNode in scene.rootNode.childNodes {
            if childNode.camera == nil {
                addChildNode(childNode)
            }
            
        }
    }
}

public extension SCNParticleSystem {
    
    public class func flSystem(named:String) -> SCNParticleSystem? {
        
        let system = SCNParticleSystem(named: named, inDirectory: nil)
        system?.particleImage = UIImage.particleImage(named: "spark")
        return system
    }
    
}

public extension UIImage {
 
    public class func particleImage(named:String) -> UIImage? {
        let bundle = Bundle(for: Map3DScene.self)
        let path = bundle.path(forResource: named, ofType: "png", inDirectory: "particles")!
        return UIImage(contentsOfFile: path)
    }
    
    public class func sceneImage(named:String) -> UIImage? {
        let bundle = Bundle(for: Map3DScene.self)
        let path = bundle.path(forResource: named, ofType: "png", inDirectory: "textures")!
        return UIImage(contentsOfFile: path)
    }
    
    public class func sceneSprite(named:String) -> UIImage? {
        let bundle = Bundle(for: Map3DScene.self)
        let path = bundle.path(forResource: named, ofType: "png", inDirectory: "sprites")!
        return UIImage(contentsOfFile: path)
    }
    
}
