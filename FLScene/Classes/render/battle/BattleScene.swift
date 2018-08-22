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
    var playerCharacter:BattleCharacter!
    
    public var target:FLSpriteComponent!
    var enemy2Sprite:FLSpriteComponent!
    let spellManager:SpellManager
    let characterManager:CharacterManager
    
    public init(island:DungeonModel) {
        self.island = island;
        self.islandNode = Hex3DMapNode(dungeon: self.island,gridSpacing:2.0)
        self.spellManager = SpellManager()
        self.characterManager = CharacterManager(spellManager: spellManager,island:island)
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
        
        let defaultSpell = SpellModel(type:.bolt)
        let longRangeSpell = SpellModel(type:.bolt)
        let healSpell = SpellModel(type: .heal)
        //let teleportSpell = SpellModel(type:.teleport)
        longRangeSpell.rangePoints = 4
        
        let spells = [defaultSpell,longRangeSpell,healSpell]
        
        let playerEntity = GridEntity()
        playerEntity.gridPosition = vector2(0, 0)
        playerCharacter = BattleCharacter(spells: spells,playerNumber:1)
        playerEntity.addComponent(CharacterComponent(character: playerCharacter))
        self.playerSprite = addSprite(entity: playerEntity, imageNamed: "alienPink")
        
        let targetEntity = GridEntity()
        targetEntity.gridPosition = vector2(2, 1)
        targetEntity.addComponent(BattleAIComponent(island:island))
        targetEntity.addComponent(CharacterComponent(character: BattleCharacter(spells: spells,playerNumber:2)))
        self.target = addSprite(entity: targetEntity, imageNamed: "alienBlue")
        
        let enemy2 = GridEntity()
        enemy2.gridPosition = vector2(0, 1)
        enemy2.addComponent(BattleAIComponent(island:island))
        enemy2.addComponent(CharacterComponent(character: BattleCharacter(spells: spells,playerNumber:1)))
        self.enemy2Sprite = addSprite(entity: enemy2, imageNamed: "alienGreen")
        
        
        playerEntity.setTarget(entity: targetEntity,show: true)
        
        
        targetEntity.setTarget(entity: enemy2)
        enemy2.setTarget(entity: targetEntity)
        
        self.characterManager.add(entity: playerEntity)
        self.characterManager.add(entity: targetEntity)
        self.characterManager.add(entity: enemy2)
    }
    
    func fireSpell(spell:SpellModel) {
        guard let spellComponent = self.playerSprite.entity?.component(ofType: SpellCastingComponent.self) else { return }
        spellComponent.castSpell(spell: spell)
    }
    
    func stopSpell(spell:SpellModel) {
        guard let spellComponent = self.playerSprite.entity?.component(ofType: SpellCastingComponent.self) else { return }
        spellComponent.stopSpell(spell: spell)
    }
    
    private func addSprite(entity:GridEntity,imageNamed:String) -> FLSpriteComponent {
        let spriteImage = UIImage.sceneSprite(named: imageNamed)!
        let playerNumber = entity.component(ofType: CharacterComponent.self)!.character.playerNumber
        let spriteNode = FLMapSprite(image: spriteImage,mapScene:self,playerNumber:playerNumber)
        let spriteComponent = FLSpriteComponent(sprite: spriteNode)
        spriteNode.entity = entity
        entity.addComponent(spriteComponent)
        islandNode.addChildNode(spriteNode)
        
        island.addBeing(entity: entity)
        spriteComponent.placeAt(position: entity.gridPosition,inDungeon: island)
        return spriteComponent
    }
    
    func pointFor(position:vector_int2,inDungeon dungeon:DungeonModel) -> SCNVector3 {
        return islandNode.topPosition(at: position)
    }
    
    func playerSpell(index:Int) -> SpellModel? {
        if index >= 0 && index < playerCharacter.spells.count {
            return playerCharacter.spells[index]
        }
        return nil;
    }
    
}
