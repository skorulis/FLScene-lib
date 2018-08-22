//
//  CharacterManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class CharacterManager: NSObject {

    private var entities:[GridEntity] = []
    let characterComponentSystem = GKComponentSystem(componentClass: CharacterComponent.self)
    let aiComponentSystem = GKComponentSystem(componentClass: BattleAIComponent.self)
    let targetSystem = GKComponentSystem(componentClass: TargetComponent.self)
    
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
    }
    
    func update(deltaTime seconds: TimeInterval) {
        characterComponentSystem.update(deltaTime: seconds)
        aiComponentSystem.update(deltaTime: seconds)
        targetSystem.update(deltaTime: seconds)
        
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
    
}
