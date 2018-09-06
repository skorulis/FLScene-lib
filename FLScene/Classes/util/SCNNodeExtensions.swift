//
//  SCNNodeExtensions.swift
//  Pods
//
//  Created by Alexander Skorulis on 1/9/18.
//

import SceneKit

extension SCNNode {

    func scaledBoundingBox() -> (min:SCNVector3,max:SCNVector3) {
        let box = self.boundingBox
        let scaledMin = box.min * self.scale
        let scaledMax = box.max * self.scale
        
        return (min:scaledMin,max:scaledMax)
    }
    
    //How much this node needs to be moved up so that it is sitting flat
    func yOffset() -> ASFloat {
        return -1 * self.boundingBox.min.y
    }
    
}
