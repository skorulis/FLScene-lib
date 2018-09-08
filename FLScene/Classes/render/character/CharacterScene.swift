//
//  CharacterScene.swift
//  CCTextFieldEffects
//
//  Created by Alexander Skorulis on 8/9/18.
//

import SceneKit

public class CharacterScene: BaseScene, MapSceneProtocol {

    let island:DungeonModel
    let islandNode:MapIslandNode
    var playerEntity:GridEntity!
    var character:CharacterModel
    
    var characterManager:CharacterManager!
    
    public init(island:DungeonModel,character:CharacterModel) {
        self.island = island
        self.character = character
        self.islandNode = MapIslandNode(dungeon: self.island,gridSpacing:2.0)
        super.init()
        self.characterManager = CharacterManager(spellManager: nil,scene:self)
        buildScene()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildScene() {
        cameraNode.position = SCNVector3(x: 0, y: 4, z: 10)
        cameraNode.look(at: SCNVector3())
        
        self.rootNode.addChildNode(islandNode)
        let act1 = SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: 6)
        let act2 = SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: 6)
        islandNode.runAction(SCNAction.repeatForever(SCNAction.sequence([act1,act2])))
        
        playerEntity = makeEntity(character: character, playerNumber: 1, position: vector_int2(0,0))
    }
    
    func makeEntity(character:CharacterModel,playerNumber:Int,position:vector_int2) -> GridEntity {
        let location = LocationModel(gridPosition: position, islandName: "battle")
        let entity = GridEntity(location: location)
        characterManager.addSprite(entity: entity, imageNamed: character.spriteName)
        
        return entity
    }
    
    //MARK: MapSceneProtocol
    
    public func pointFor(position:vector_int2,inDungeon dungeon:DungeonModel) -> SCNVector3 {
        return islandNode.topPosition(at: position)
    }
    
    public func island(named:String) -> DungeonModel {
        return self.island
    }
    
    public func islandFor(dungeon:DungeonModel) -> MapIslandNode {
        return self.islandNode
    }
    
    public var bridges:BridgeContainerNode {
        return BridgeContainerNode()
    }
    
}
