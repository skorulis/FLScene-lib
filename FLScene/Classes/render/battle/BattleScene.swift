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
    var playerEntity:GridEntity!
    var enemy1Entity:GridEntity!
    
    let spellManager:SpellManager
    var characterManager:CharacterManager!
    
    var spells:[SpellModel] = []
    public let bridges: BridgeContainerNode
    
    public init(island:DungeonModel) {
        self.island = island;
        bridges = BridgeContainerNode()
        self.islandNode = Hex3DMapNode(dungeon: self.island,gridSpacing:2.0)
        self.spellManager = SpellManager(islandNode: islandNode)
        super.init()
        self.characterManager = CharacterManager(spellManager: spellManager,scene:self)
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
        
        let defaultSpell = SpellModel(type:.bolt,effect:.damage)
        let longRangeSpell = SpellModel(type:.bolt,effect:.damage)
        let healSpell = SpellModel(type: .channel,effect:.heal)
        let totemSpell = SpellModel(type: .totem,effect:.mana)
        //let teleportSpell = SpellModel(type:.teleport)
        longRangeSpell.rangePoints = 4
        
        spells = [defaultSpell,longRangeSpell,healSpell,totemSpell]
        
        playerEntity = makePlayerEntity(spells: spells,playerNumber: 1)
        playerEntity.gridPosition = vector2(0, 0)
        _ = characterManager.makeSprite(entity: playerEntity, imageNamed: "alienPink")
        
        enemy1Entity = makePlayerEntity(spells: spells,playerNumber: 2)
        enemy1Entity.gridPosition = vector2(2, 1)
        enemy1Entity.addComponent(BattleAIComponent(island:island,spells:spellManager))
        _ = characterManager.makeSprite(entity: enemy1Entity, imageNamed: "alienBlue")

        playerEntity.setTarget(entity: enemy1Entity,show: true)
        enemy1Entity.setTarget(entity: playerEntity)
        
        makeSecondAI()
        
        self.characterManager.add(entity: playerEntity)
        self.characterManager.add(entity: enemy1Entity)
        
    }
    
    private func makePlayerEntity(spells:[SpellModel],playerNumber:Int) -> GridEntity {
        let playerEntity = GridEntity()
        playerEntity.islandName = "battle"
        let playerCharacter = BattleCharacter(spells: spells,playerNumber:playerNumber)
        playerEntity.addComponent(CharacterComponent(character: playerCharacter))
        
        return playerEntity
    }
    
    func makeSecondAI() {
        let enemy2 = makePlayerEntity(spells: spells, playerNumber: 1)
        enemy2.gridPosition = vector2(0, 1)
        enemy2.addComponent(BattleAIComponent(island:island,spells:spellManager))
        _ = characterManager.makeSprite(entity: enemy2, imageNamed: "alienGreen")
        
        enemy1Entity.setTarget(entity: enemy2)
        enemy2.setTarget(entity: enemy1Entity)
        
        self.characterManager.add(entity: enemy2)
    }
    
    func playerCastingComponent() -> SpellCastingComponent {
        return playerEntity.component(ofType: SpellCastingComponent.self)!
    }
    
    func playerSpell(index:Int) -> SpellModel? {
        let component = playerEntity.component(ofType: CharacterComponent.self)!
        let spells = component.character.spells
        if index >= 0 && index < spells.count {
            return spells[index]
        }
        return nil;
    }
    
    //MARK: - MapSceneProtocol
    
    public func pointFor(position:vector_int2,inDungeon dungeon:DungeonModel) -> SCNVector3 {
        return islandNode.topPosition(at: position)
    }
    
    public func island(named:String) -> DungeonModel {
        return self.island
    }
    
    public func islandFor(dungeon:DungeonModel) -> Hex3DMapNode {
        return self.islandNode
    }
    
}
