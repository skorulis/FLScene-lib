//
//  LandPieceNode.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/8/18.
//

import SceneKit
import SKSwiftLib

public class LandPieceNode: SCNNode {

    public let dungeonNode:MapHexModel
    private var sideNode:SCNNode?
    private var hexNode:SCNNode?
    
    var highlighted:Bool = false {
        didSet {
            let scale = highlighted ? 0.75 : 1.0
            self.scale = SCNVector3(scale,scale,scale)
            /*let content:Any? = highlighted ? UIColor.red : UIColor.clear
            for node in self.childNodes {
                node.geometry?.firstMaterial?.emission.contents = content
            }*/
        }
    }
    
    init(dungeonNode:MapHexModel) {
        self.dungeonNode = dungeonNode
        super.init()
        self.rebuildTerrainGeometry()
        
        if let fixture = dungeonNode.fixture {
            let model = fixtureNode(type: fixture.ref.type)
            sitNode(node: model)
            
            let hexGeometry = GeometryProvider.instance.bevelHex(ref:dungeonNode.terrain)
            
            if fixture.ref.type == .teleporter {
                if let trail = SCNParticleSystem.flSystem(named: "teleporter") {
                    trail.emitterShape = hexGeometry
                    self.addParticleSystem(trail)
                }
            }
        }
    }
    
    private func fixtureNode(type:DungeonTileType) -> SCNNode {
        switch type {
        case .house:
            return NodeProvider.instance.house()
        default:
            return NodeProvider.instance.tree()
        }
    }
    
    public func rebuildTerrainGeometry() {
        self.sideNode?.removeFromParentNode()
        self.hexNode?.removeFromParentNode()
        
        let terrain = dungeonNode.terrain
        let hexMath = Hex3DMath(baseSize: 1)
        let hexGeometry = GeometryProvider.instance.bevelHex(ref:terrain)
        let sides = GeometryProvider.instance.sideGeometry(height:hexMath.height(),ref:terrain)
        self.hexNode = SCNNode(geometry: hexGeometry)
        self.sideNode = SCNNode(geometry: sides)
        self.addChildNode(hexNode!)
        self.addChildNode(sideNode!)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sitNode(node:SCNNode) {
        let hexMath = Hex3DMath(baseSize: 1)
        self.addChildNode(node)
        let minY = CGFloat(node.boundingBox.min.y)
        
        node.position = SCNVector3(0,hexMath.height()/2 - minY,0) + node.position
        
        /*let constraint = SCNDistanceConstraint(target: self)
        constraint.maximumDistance = 0.1
        node.constraints = [constraint]*/
    }
    
    private func sitGeometry(geometry:SCNGeometry) {
        let node = SCNNode(geometry: geometry)
        sitNode(node: node)
    }
    
    func containingMap() -> Hex3DMapNode {
        return self.parent! as! Hex3DMapNode
    }
    
    public override var debugDescription: String {
        return "land node pos \(self.position), grid pos \(self.dungeonNode.gridPosition)"
    }
    
}
