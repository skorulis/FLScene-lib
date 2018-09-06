//
//  OverlandScene
//  floatios
//
//  Created by Alexander Skorulis on 2/8/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SceneKit
import SKSwiftLib
import GameplayKit

public class OverlandScene: SCNScene, MapSceneProtocol {

    public var overland:FullOverlandModel
    private let floorY:Float = -10
    var playerEntity:GridEntity!
    
    private var characterManager:CharacterManager!
    
    public var playerIsland:DungeonModel {
        return overland.findIsland(name: playerEntity.islandName!)
    }
    
    public var playerIslandNode:MapIslandNode {
        return islandFor(dungeon: playerIsland)
    }
    
    private let game:GameController
    var islands:[MapIslandNode] = []
    public let bridges:BridgeContainerNode
    var skybox:SkyboxManager!
    var npcs:[GridEntity] = []
    
    public override init() {
        self.game = GameController.instance
        self.bridges = BridgeContainerNode()
        
        self.overland = OverlandGenerator.fromFile()
        
        super.init()
        self.skybox = SkyboxManager(scene: self)
        self.rootNode.addChildNode(self.bridges)
        self.characterManager = CharacterManager(spellManager: nil, scene: self)
        self.buildScene()
        self.bridges.buildNodes(bridgeModels: self.overland.bridges, overland: self)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildScene() {
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SceneElements.ambientLight()
        rootNode.addChildNode(ambientLightNode)
        
        skybox.updateSkybox()
        
        self.islands = self.overland.dungeons.map { self.makeMap(dungeon: $0)}
        for i in islands {
            let duration = Double(arc4random()) / Double(UINT32_MAX)
            let act1 = SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: duration + 5)
            let act2 = SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: duration + 5)
            i.runAction(SCNAction.repeatForever(SCNAction.sequence([act1,act2])))
            self.rootNode.addChildNode(i)
            
        }
        
        buildWater()
        
        for _ in 0...15 {
            addRock()
        }
        
        let character:CharacterModel = CharacterModel()
        character.location = LocationModel(gridPosition: vector2(3, 3), islandName: "Obl")
        
        self.playerEntity = makeEntity(character: character)
        
        let npcModels:[NonPlayerCharacterModel] = ReferenceController.readReferenceObjects(filename: "npcs")
        self.npcs = npcModels.map({ (char) -> GridEntity in
            let entity = makeEntity(character: char.base)
            let component = NPCComponent(npc: char)
            entity.addComponent(component)
            return entity
        })
    }
    
    public func makeEntity(character:CharacterModel) -> GridEntity {
        let playerEntity = GridEntity(location: character.location!)
        characterManager.addSprite(entity: playerEntity, imageNamed: character.spriteName)
        
        return playerEntity
    }
    
    private func buildWater() {
        let tileSize:CGFloat = 25
        for x in -5...5 {
            for z in -5...5 {
                let geom = SCNPlane(width: tileSize, height: tileSize)
                
                geom.firstMaterial = MaterialProvider.floorMaterial()
                
                let floor = SCNNode(geometry: geom)
                floor.rotation = SCNVector4(1,0,0,-CGFloat.pi/2)
                floor.position = SCNVector3(tileSize * CGFloat(x),CGFloat(floorY),tileSize * CGFloat(z))
                
                self.rootNode.addChildNode(floor)
            }
        }
        
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
    
    public func makeMap(dungeon:DungeonModel) -> MapIslandNode {
        let mapGrid = MapIslandNode(dungeon: dungeon)
        //let sphere = mapGrid.boundingSphere
        //mapGrid.position = SCNVector3(-sphere.center.x,0,-sphere.center.z) + dungeon.overlandOffset
        mapGrid.position = dungeon.overlandOffset - mapGrid.centreOffset()
        return mapGrid
    }
    
    func teleportPlayer(dungeon:DungeonModel,node:MapHexModel) {
        overland.changeEntityIsland(entity: playerEntity, islandName: dungeon.name, position: node.gridPosition)
        let component = playerEntity.component(ofType: MovementComponent.self)
        component?.moveTo(position: node.gridPosition,inDungeon:dungeon)
    }
    
    //MARK: - MapSceneProtocol
    
    public func islandFor(dungeon:DungeonModel) -> MapIslandNode {
        return self.islands.filter { $0.dungeon === dungeon}.first!
    }
    
    public func island(named:String) -> DungeonModel {
        return self.islands.filter { $0.dungeon.name == named}.first!.dungeon
    }
    
    public func pointFor(position:vector_int2,inDungeon dungeon:DungeonModel) -> SCNVector3 {
        let island = self.islandFor(dungeon: dungeon)
        return island.topPosition(at: position) + dungeon.overlandOffset - island.centreOffset()
    }
    
}
