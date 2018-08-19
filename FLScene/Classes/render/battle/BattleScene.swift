//
//  BattleScene.swift
//  Pods
//
//  Created by Alexander Skorulis on 18/8/18.
//

import SceneKit
import SKSwiftLib
import GameplayKit

public class BattleScene: SCNScene, MapSceneProtocol {

    let island:DungeonModel
    let islandNode:Hex3DMapNode
    public var playerSprite:FLSpriteComponent!
    
    public var target:FLSpriteComponent!
    let spellManager:SpellManager
    let characterManager:CharacterManager
    
    public init(island:DungeonModel) {
        self.island = island;
        self.islandNode = Hex3DMapNode(dungeon: self.island,gridSpacing:2.0)
        self.spellManager = SpellManager()
        self.characterManager = CharacterManager()
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
        let act1 = SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: 6)
        let act2 = SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: 6)
        islandNode.runAction(SCNAction.repeatForever(SCNAction.sequence([act1,act2])))
        
        let spells = [SpellModel(),SpellModel()]
        
        let playerEntity = GridEntity()
        playerEntity.gridPosition = vector2(1, 1)
        let playerCharacter = BattleCharacter(spells: spells)
        self.playerSprite = addSprite(entity: playerEntity, imageNamed: "alienPink")
        self.characterManager.add(character:playerCharacter, entity: playerEntity)
        
        let targetEntity = GridEntity()
        targetEntity.gridPosition = vector2(2, 1)
        let targetCharacter = BattleCharacter(spells: spells)
        self.target = addSprite(entity: targetEntity, imageNamed: "alienBlue")
        self.characterManager.add(character:targetCharacter, entity: targetEntity)
    }
    
    func fireSpell(index:Int) {
        guard let component = self.playerSprite.entity?.component(ofType: CharacterComponent.self) else { return }
        guard index >= 0 && index < component.character.spells.count else { return }
        let spell = component.character.spells[index]
        
        guard component.hasMana(cost: spell.cost()) else { return }
        spellManager.addSpell(spell: spell, caster: self.playerSprite.sprite, target: self.target.sprite, inScene: self)
        component.takeMana(amount: spell.cost())
    }
    
    private func addSprite(entity:GridEntity,imageNamed:String) -> FLSpriteComponent {
        let spriteNode = FLMapSprite(image: UIImage.sceneSprite(named: imageNamed)!,mapScene:self)
        let spriteComponent = FLSpriteComponent(sprite: spriteNode)
        spriteNode.entity = entity
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
