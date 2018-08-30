//
//  SkyboxManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 30/8/18.
//

import SceneKit
import SKSwiftLib

class SkyboxManager: NSObject {

    weak var scene:SCNScene?
    private let skybox:MDLSkyCubeTexture
    private var isRendering:Bool = false
    
    init(scene:SCNScene) {
        self.scene = scene
        self.skybox = SkyboxManager.defaultSkybox()
    }
    
    func updateSkybox() {
        guard let scene = self.scene else { return }
        
        isRendering = true
        self.skybox.update()
        
        scene.background.contents = skybox.imageFromTexture()?.takeUnretainedValue()
        scene.lightingEnvironment.contents = scene.background.contents
        isRendering = false
    }
    
    func animateToTime(time:TimeInterval) {
        let animation = SCNAction.customAction(duration: 2) { (node, current) in
            let pct = current/2
            let showTime = time * TimeInterval(pct)
            
            print("update skybox time \(showTime)" )
            
            if !self.isRendering {
                DispatchQueue.global().async {
                    self.skybox.sunElevation = Float(showTime)
                    self.skybox.brightness = Float(showTime) * 0.5
                    self.updateSkybox()
                }
            }
            
        }
        
        
        scene?.rootNode.runAction(animation)
    }
    
    class func defaultSkybox() -> MDLSkyCubeTexture {
        let skyBox = MDLSkyCubeTexture(name: nil, channelEncoding: MDLTextureChannelEncoding.uInt8,
                                       textureDimensions: [Int32(64), Int32(64)], turbidity: 0.4, sunElevation: 0.7, upperAtmosphereScattering: 0.2, groundAlbedo: 2)
        skyBox.groundColor = UIColor.brown.cgColor
        
        return skyBox
    }
    
}
