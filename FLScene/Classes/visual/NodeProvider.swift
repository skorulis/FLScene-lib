//
//  NodeProvider.swift
//  Pods
//
//  Created by Alexander Skorulis on 12/8/18.
//

import SceneKit

//Provide fully constructed nodes to be placed in the scene
class NodeProvider {

    static let instance = NodeProvider()
    
    let store:GeometryStore
    
    init() {
        store = GeometryStore()
    }
    
    public func tree() -> SCNNode {
        return getNode(named: "tree", fromScene: "scene1.scn",maxSize: SCNVector3(0.5,2,0.5))
    }
    
    public func house() -> SCNNode {
        let geom = SCNPyramid(width: 1.4, height: 1, length: 1.4)
        geom.firstMaterial = MaterialProvider.bridgeStoneMaterial()
        return SCNNode(geometry: geom)
    }
    
    private func getNode(named:String,fromScene:String,maxSize:SCNVector3) -> SCNNode {
        let scene = store.getScene(name: fromScene)
        let childNode = scene.rootNode.childNode(withName: named, recursively: true)!
        let clone = childNode.clone()
        
        let yOffset = -3.6
        
        clone.position = SCNVector3(0,yOffset,0)
        
        //let scale = nodeScale(node: clone, maxSize: maxSize)
        //clone.scale = SCNVector3(scale,scale,scale)
        
        return clone
    }
    
    private func nodeScale(node:SCNNode,maxSize:SCNVector3) -> CGFloat {
        let sizeX = node.boundingBox.max.x - node.boundingBox.min.x
        let sizeY = node.boundingBox.max.y - node.boundingBox.min.y
        let sizeZ = node.boundingBox.max.z - node.boundingBox.min.z
        let scaleX = maxSize.x / sizeX
        let scaleY = maxSize.y / sizeY
        let scaleZ = maxSize.z / sizeZ
        
        return CGFloat([scaleX,scaleY,scaleZ].min()!)
    }
}
