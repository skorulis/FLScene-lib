//
//  BattleScene.swift
//  Pods
//
//  Created by Alexander Skorulis on 18/8/18.
//

import SceneKit
import SKSwiftLib

public class BattleScene: SCNScene, MapSceneProtocol {

    let island:DungeonModel
    private let islandNode:Hex3DMapNode
    public var playerSprite:FLSpriteComponent!
    
    public var target:FLSpriteComponent!
    
    public init(island:DungeonModel) {
        self.island = island;
        self.islandNode = Hex3DMapNode(dungeon: self.island,gridSpacing:2.0)
        super.init()
        self.buildScene()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildScene() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SceneElements.ambientLight()
        rootNode.addChildNode(ambientLightNode)
        
        let skyBox = SceneElements.skyBox()
        
        self.background.contents = skyBox.imageFromTexture()?.takeUnretainedValue()
        self.lightingEnvironment.contents = self.background.contents
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 4, z: 15)
        cameraNode.look(at: SCNVector3())
        
        self.rootNode.addChildNode(islandNode)
        
        let playerEntity = GridEntity()
        playerEntity.gridPosition = vector2(1, 1)
        self.playerSprite = addSprite(entity: playerEntity, imageNamed: "alienPink")
        
        let targetEntity = GridEntity()
        targetEntity.gridPosition = vector2(2, 1)
        self.target = addSprite(entity: targetEntity, imageNamed: "alienBlue")
        
        fireSpell()
    }
    
    func fireSpell() {
        let geometry = SCNSphere(radius: 0.25)
        
        geometry.firstMaterial = MaterialProvider.floorMaterial()
        let node = SCNNode(geometry: geometry)
        node.position = self.playerSprite.sprite.position
        rootNode.addChildNode(node)
        
        let moveAction = SCNAction.move(to: target.sprite.position, duration: 0.4)
        moveAction.timingMode = .easeIn
        let removeAction = SCNAction.removeFromParentNode()
        let sequence = SCNAction.sequence([moveAction,removeAction])
        node.runAction(sequence)
    }
    
    private func addSprite(entity:GridEntity,imageNamed:String) -> FLSpriteComponent {
        let spriteNode = FLMapSprite(image: UIImage.sceneSprite(named: imageNamed)!,mapScene:self)
        let spriteComponent = FLSpriteComponent(sprite: spriteNode)
        entity.addComponent(spriteComponent)
        islandNode.addChildNode(spriteNode)
        
        island.addMonster(entity: entity)
        spriteComponent.placeAt(position: entity.gridPosition,inDungeon: island)
        return spriteComponent
    }
    
    func pointFor(position:vector_int2,inDungeon dungeon:DungeonModel) -> SCNVector3 {
        return islandNode.topPosition(at: position)
    }
    
}
