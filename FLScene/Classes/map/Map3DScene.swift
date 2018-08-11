//
//  Map3DScene.swift
//  floatios
//
//  Created by Alexander Skorulis on 2/8/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SceneKit
import SKSwiftLib

public class Map3DScene: SCNScene {

    public var overland:FullOverlandModel
    
    private let floorY:Float = -10
    
    public var playerSprite:FLSpriteComponent!
    public var playerIsland:Hex3DMapNode {
        return self.islandFor(dungeon: overland.playerDungeon!)
    }
    
    private let game:GameController
    private var islands:[Hex3DMapNode] = []
    
    
    public override init() {
        self.game = GameController.instance
        
        let gen = OverlandGenerator()
        
        self.overland = gen.baseOverland()

        super.init()
        self.buildScene()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildScene() {
        // create and add a light to the scene
        /*let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        rootNode.addChildNode(ambientLightNode)*/
        
        let skyBox = MDLSkyCubeTexture(name: nil, channelEncoding: MDLTextureChannelEncoding.uInt8,
                                       textureDimensions: [Int32(160), Int32(160)], turbidity: 0.4, sunElevation: 0.7, upperAtmosphereScattering: 0.2, groundAlbedo: 2)
        skyBox.groundColor = UIColor.brown.cgColor
        
        self.background.contents = skyBox.imageFromTexture()?.takeUnretainedValue()
        self.lightingEnvironment.contents = self.background.contents

        self.islands = self.overland.dungeons.map { self.makeMap(dungeon: $0)}
        for i in islands {
            let duration = Double(arc4random()) / Double(UINT32_MAX)
            let act1 = SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: duration + 5)
            let act2 = SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: duration + 5)
            i.runAction(SCNAction.repeatForever(SCNAction.sequence([act1,act2])))
            self.rootNode.addChildNode(i)
        }
        
        
        if let playerNode = self.overland.playerDungeon?.playerNode {
            self.playerSprite = addSprite(entity: playerNode, imageNamed: "alienPink")
        }
        
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
        let geometry = GeometryProvider.instance.bevelHex(ref:terrain)
        let sides = GeometryProvider.instance.sideGeometry(height: 4,ref:terrain)
        
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
    
    public func makeMap(dungeon:DungeonModel) -> Hex3DMapNode {
        let mapGrid = Hex3DMapNode(dungeon: dungeon)
        let sphere = mapGrid.boundingSphere
        mapGrid.position = SCNVector3(-sphere.center.x,0,-sphere.center.z) + dungeon.overlandOffset
        return mapGrid
    }
    
    func pointFor(position:vector_int2,inDungeon dungeon:DungeonModel) -> SCNVector3 {
        let island = self.islandFor(dungeon: dungeon)
        return island.topPosition(at: position) + dungeon.overlandOffset
    }
    
    func addSprite(entity:GridEntity,imageNamed:String) -> FLSpriteComponent {
        let spriteNode = FLMapSprite(image: UIImage.sceneImage(named: imageNamed)!,mapScene:self)
        let spriteComponent = FLSpriteComponent(sprite: spriteNode)
        entity.addComponent(spriteComponent)
        let island = self.islandFor(dungeon: self.overland.playerDungeon!)
        island.addChildNode(spriteNode)
        
        spriteComponent.placeAt(position: entity.gridPosition,inDungeon: self.overland.playerDungeon!)
        return spriteComponent
    }
    
    func teleportPlayer(dungeon:DungeonModel,node:GKHexMapNode) {
        overland.changePlayerDungeon(player: game.player.player, dungeon: dungeon)
        playerSprite.moveTo(position: node.gridPosition,inDungeon:dungeon)
        
    }
    
    func islandFor(dungeon:DungeonModel) -> Hex3DMapNode {
        return self.islands.filter { $0.dungeon == dungeon}.first!
    }
    
}
