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
    let islandNode:MapIslandNode
    var playerEntity:GridEntity!
    var enemy1Entity:GridEntity!
    
    let spellManager:SpellManager
    var characterManager:CharacterManager!
    var battleManager:BattleManager!
    var skybox:SkyboxManager!
    
    var spells:[SpellModel] = []
    public let bridges: BridgeContainerNode
    var battleModel:ArenaBattleModel
    let playerCharacter:CharacterModel
    
    public init(island:DungeonModel,battleModel:ArenaBattleModel,playerCharacter:CharacterModel) {
        self.island = island;
        self.battleModel = battleModel
        self.playerCharacter = playerCharacter
        bridges = BridgeContainerNode()
        self.islandNode = MapIslandNode(dungeon: self.island,gridSpacing:2.0)
        self.spellManager = SpellManager(islandNode: islandNode)
        super.init()
        self.skybox = SkyboxManager(scene: self)
        self.characterManager = CharacterManager(spellManager: spellManager,scene:self)
        self.battleManager = BattleManager(scene: self, model: battleModel)
        self.buildScene()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buildScene() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SceneElements.ambientLight()
        rootNode.addChildNode(ambientLightNode)
        
        skybox.updateSkybox()
        
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
        longRangeSpell.rangePoints = 4
        
        spells = [defaultSpell,longRangeSpell,healSpell,totemSpell]
        self.resetBattle()
    }
    
    func makeEntity(character:CharacterModel,playerNumber:Int,position:vector_int2) -> GridEntity {
        let location = LocationModel(gridPosition: position, islandName: "battle")
        let entity = GridEntity(location: location)
        characterManager.addSprite(entity: entity, imageNamed: character.spriteName)
        character.updateStats() //Make sure stats are up to date
        entity.addComponent(CharacterComponent(character: character,playerNumber:playerNumber))
        entity.addComponent(CharacterEventComponent())
        
        return entity
    }
    
    //Puts the player back to the start and resets everything
    func resetBattle() {
        self.battleManager.reset()
        self.characterManager.reset()
        self.spellManager.reset()
        
        if playerEntity != nil {
            let events = playerEntity.component(ofType: CharacterEventComponent.self)!
            events.printResults()
        }
        
        playerCharacter.buffs.removeAll()
        playerEntity = makeEntity(character: playerCharacter, playerNumber: 1,position: battleModel.playerStartPosition)
        
        //Give the player an AI for now so I don't have to control it
        let ai = BattleAIComponent(island:island,spells:spellManager,characterManager:characterManager)
        ai.isPlayerAI = true
        playerEntity.addComponent(ai)
        self.characterManager.add(entity: playerEntity)
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
    
    public func islandFor(dungeon:DungeonModel) -> MapIslandNode {
        return self.islandNode
    }
    
}
