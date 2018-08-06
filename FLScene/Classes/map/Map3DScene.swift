//
//  Map3DScene.swift
//  floatios
//
//  Created by Alexander Skorulis on 2/8/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SceneKit
import FLGame
import SKSwiftLib

public class Map3DScene: SCNScene {

    public var mapGrid:Hex3DMapNode!
    
    public let dungeon:DungeonModel
    public let hexGeometry:HexGeometry
    
    private let floorY:Float = -10
    
    public init(dungeon:DungeonModel) {
        self.dungeon = dungeon
        let store = GeometryStore()
        hexGeometry = HexGeometry(store:store)
        super.init()
        self.buildScene()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildScene() {
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        rootNode.addChildNode(ambientLightNode)
        
        let skyBox = MDLSkyCubeTexture(name: nil, channelEncoding: MDLTextureChannelEncoding.uInt8,
                                       textureDimensions: [Int32(160), Int32(160)], turbidity: 0.4, sunElevation: 0.7, upperAtmosphereScattering: 0.2, groundAlbedo: 2)
        skyBox.groundColor = UIColor.brown.cgColor
        
        self.background.contents = skyBox.imageFromTexture()?.takeUnretainedValue()

        
        mapGrid = self.makeMap()
        self.rootNode.addChildNode(mapGrid)
        
        let mapGrid2 = self.makeMap()
        mapGrid2.position = SCNVector3(22,0,15)
        self.rootNode.addChildNode(mapGrid2)
        
        let act1 = SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: 5)
        let act2 = SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: 5)
        mapGrid.runAction(SCNAction.repeatForever(SCNAction.sequence([act1,act2])))
        
        let plane = SCNPlane(width: 1, height: 2)
        plane.firstMaterial?.diffuse.contents = UIImage.sceneImage(named: "alienPink")
        
        let planeNode = SCNNode(geometry:plane)
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = SCNBillboardAxis.Y
        planeNode.constraints = [constraint]
        
        planeNode.position = mapGrid.topPosition(at: vector2(2,2)) + SCNVector3(0,1,0)
        mapGrid.addChildNode(planeNode)
        
        buildWater()
        
        for _ in 0...15 {
            addRock()
        }
    }
    
    private func buildWater() {
        let geom = SCNFloor()
        
        geom.firstMaterial = MaterialProvider.floorMaterial()
        
        let floor = SCNNode(geometry: geom)
        floor.position = SCNVector3(0,floorY,0)
        
        self.rootNode.addChildNode(floor)
    }
    
    private func addRock() {
        let terrain = GameController.instance.reference.getTerrain(type: .redRock)
        let geometry = hexGeometry.bevelHex(ref:terrain)
        let sides = hexGeometry.sideGeometry(height: 4,ref:terrain)
        
        sides.firstMaterial = MaterialProvider.sideMaterial(ref: terrain)
        
        let top = SCNNode(geometry: geometry)
        let sidesNode = SCNNode(geometry: sides)
        sidesNode.position = SCNVector3(0,-1.5,0)
        
        let node = SCNNode()
        node.addChildNode(top)
        node.addChildNode(sidesNode)
        
        let x = Float(arc4random_uniform(80)) - 40
        let z = Float(arc4random_uniform(80)) - 40
        let scale = Float(arc4random_uniform(50) + 50) / 100
        
        node.scale = SCNVector3(scale,scale,scale)
        
        let nodeY = floorY + (3.5 * scale) - 0.5
        
        node.position = SCNVector3(x,nodeY,z)
        
        self.rootNode.addChildNode(node)
    }
    
    public func makeMap() -> Hex3DMapNode {
        let mapGrid = Hex3DMapNode(dungeon: dungeon,gen:hexGeometry)
        let sphere = mapGrid.boundingSphere
        mapGrid.position = SCNVector3(-sphere.center.x,0,-sphere.center.z)
        return mapGrid
    }
    
}
