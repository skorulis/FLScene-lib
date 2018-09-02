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
    
    let spellManager:SpellManager?
    weak var scene:MapSceneProtocol?
    
    init(spellManager:SpellManager?,scene:MapSceneProtocol) {
        self.spellManager = spellManager
        self.scene = scene
        super.init()
    }
    
    func add(entity:GridEntity) {
        if let spellManager = spellManager {
            entity.addComponent(SpellCastingComponent(spellManager: spellManager))
        }
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
                battleComponent.deathCount += 1
                print("player \(battleComponent.playerNumber) has died \(battleComponent.deathCount) times")
                
                let sprite = entity.component(ofType: MovementComponent.self)
                let island = scene!.island(named: entity.islandName!)
                let spawn = island.randomEmptySquare()
                sprite?.placeAt(position: spawn.gridPosition, inDungeon: island)
                //TODO: Add death and rebirth effects. Maybe a slight delay
            }
        }
    }
    
    func makeSprite(entity:GridEntity,imageNamed:String) -> MovementComponent {
        let spriteImage = UIImage.sceneSprite(named: imageNamed)!
        
        let playerNumber = entity.component(ofType: CharacterComponent.self)?.playerNumber ?? 0
        let spriteNode = FLMapSprite(image: spriteImage,playerNumber:playerNumber)
        let spriteComponent = MovementComponent(scene:scene!)
        spriteNode.entity = entity
        let island = scene!.island(named: entity.islandName!)
        let islandNode = scene!.islandFor(dungeon: island)
        entity.addComponent(spriteComponent)
        entity.addComponent(GKSCNNodeComponent(node: spriteNode))
        islandNode.addChildNode(spriteNode)
        
        islandNode.dungeon.addBeing(entity: entity)
        spriteComponent.placeAt(position: entity.gridPosition,inDungeon: islandNode.dungeon)
        return spriteComponent
    }
    
    func otherEntities(playerNumber:Int) -> [GridEntity] {
        return self.entities.filter { (entity) -> Bool in
            let component = entity.component(ofType: CharacterComponent.self)!
            return component.playerNumber != playerNumber
        }
    }
    
}
