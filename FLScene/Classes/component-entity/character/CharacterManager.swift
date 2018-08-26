//
//  CharacterManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit
import SKSwiftLib

class CharacterManager: NSObject {

    private var entities:[GridEntity] = []
    let characterComponentSystem = GKComponentSystem(componentClass: CharacterComponent.self)
    let aiComponentSystem = GKComponentSystem(componentClass: BattleAIComponent.self)
    let targetSystem = GKComponentSystem(componentClass: TargetComponent.self)
    let spellSystem = GKComponentSystem(componentClass: SpellCastingComponent.self)
    
    let spellManager:SpellManager
    let island:DungeonModel
    
    init(spellManager:SpellManager,island:DungeonModel) {
        self.spellManager = spellManager
        self.island = island
        super.init()
    }
    
    func add(entity:GridEntity) {
        entity.addComponent(SpellCastingComponent(spellManager: spellManager))
        self.entities.append(entity)
        
        characterComponentSystem.addComponent(foundIn: entity)
        aiComponentSystem.addComponent(foundIn: entity)
        targetSystem.addComponent(foundIn: entity)
        spellSystem.addComponent(foundIn:entity)
    }
    
    func update(deltaTime seconds: TimeInterval) {
        characterComponentSystem.update(deltaTime: seconds)
        aiComponentSystem.update(deltaTime: seconds)
        targetSystem.update(deltaTime: seconds)
        spellSystem.update(deltaTime: seconds)
        
        self.entities.forEach { (entity) in
            let battleComponent = entity.component(ofType: CharacterComponent.self)!
            if battleComponent.isDead() {
                battleComponent.reset()
                battleComponent.character.deathCount += 1
                print("player \(battleComponent.character.playerNumber) has died \(battleComponent.character.deathCount) times")
                
                let sprite = entity.component(ofType: FLSpriteComponent.self)
                let spawn = island.randomEmptySquare()
                sprite?.placeAt(position: spawn.gridPosition, inDungeon: self.island)
                //TODO: Add death and rebirth effects. Maybe a slight delay
            }
        }
    }
    
    func makeSprite(entity:GridEntity,imageNamed:String,islandNode:Hex3DMapNode,scene:MapSceneProtocol) -> FLSpriteComponent {
        let spriteImage = UIImage.sceneSprite(named: imageNamed)!
        let playerNumber = entity.component(ofType: CharacterComponent.self)!.character.playerNumber
        let spriteNode = FLMapSprite(image: spriteImage,playerNumber:playerNumber)
        let spriteComponent = FLSpriteComponent(sprite: spriteNode,scene:scene)
        spriteNode.entity = entity
        entity.addComponent(spriteComponent)
        entity.addComponent(GKSCNNodeComponent(node: spriteNode))
        islandNode.addChildNode(spriteNode)
        
        island.addBeing(entity: entity)
        spriteComponent.placeAt(position: entity.gridPosition,inDungeon: island)
        return spriteComponent
    }
    
}
