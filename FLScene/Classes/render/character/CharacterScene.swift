//
//  CharacterScene.swift
//  CCTextFieldEffects
//
//  Created by Alexander Skorulis on 8/9/18.
//

import SceneKit

public class CharacterScene: BaseScene {

    let island:DungeonModel
    let islandNode:MapIslandNode
    var playerEntity:GridEntity!
    
    public init(island:DungeonModel,character:CharacterModel) {
        self.island = island
        self.islandNode = MapIslandNode(dungeon: self.island,gridSpacing:2.0)
        super.init()
        
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
    }
    
}
