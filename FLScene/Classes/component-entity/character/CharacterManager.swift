//
//  CharacterManager.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit
import SKSwiftLib

public class CharacterManager: NSObject {

    private var entities:[GridEntity] = []
    let characterComponentSystem = GKComponentSystem(componentClass: CharacterComponent.self)
    let aiComponentSystem = GKComponentSystem(componentClass: BattleAIComponent.self)
    let overlandAISystem = GKComponentSystem(componentClass: OverlandAIComponent.self)
    let targetSystem = GKComponentSystem(componentClass: TargetComponent.self)
    let spellSystem = GKComponentSystem(componentClass: SpellCastingComponent.self)
    let actionsSystem = GKComponentSystem(componentClass: SustainedActionComponent.self)
    
    let spellManager:SpellManager?
    let allSystems:[GKComponentSystem<GKComponent>]
    weak var scene:MapSceneProtocol?
    
    init(spellManager:SpellManager?,scene:MapSceneProtocol) {
        self.spellManager = spellManager
        self.scene = scene
        self.allSystems = [characterComponentSystem,aiComponentSystem,targetSystem,spellSystem,actionsSystem,overlandAISystem]
        super.init()
    }
    
    func add(entity:GridEntity) {
        if let spellManager = spellManager {
            entity.addComponent(SpellCastingComponent(spellManager: spellManager))
        }
        entity.addComponent(TargetComponent(target: nil)) //Add empty target component
        entity.addComponent(SustainedActionComponent())
        entity.addComponent(CharacterEventComponent())
        entity.addComponent(ActionQueueComponent())
        entity.addComponent(RewardVisualisationComponent())
        
        self.entities.append(entity)
        
        allSystems.forEach { $0.addComponent(foundIn:entity)}
        entity.components.forEach { (component) in
            if let entityComponent = component as? BaseEntityComponent {
                entityComponent.wasAddedToManager(manager: self)
            }
        }
    }
    
    func update(deltaTime seconds: TimeInterval) {
        allSystems.forEach { $0.update(deltaTime: seconds)}
        
        let dead = self.entities.filter { (entity) -> Bool in
            let battleComponent = entity.component(ofType: CharacterComponent.self)!
            return battleComponent.isDead()
        }
        self.entities = self.entities.filter({ (entity) -> Bool in
            let battleComponent = entity.component(ofType: CharacterComponent.self)!
            return !battleComponent.isDead()
        })
        
        dead.forEach(killEntity)
    }
    
    func reset() {
        self.entities.forEach(killEntity)
        self.entities = []
    }
    
    private func killEntity(entity:GridEntity) {
        let node = entity.component(ofType: GKSCNNodeComponent.self)?.node
        node?.removeFromParentNode()
        let movement = entity.component(ofType: MovementComponent.self)
        movement?.removeFromOldNode()
        
        allSystems.forEach { $0.removeComponent(foundIn: entity)}
    }
    
    func addSprite(entity:GridEntity,imageNamed:String) {
        //let spriteImage = UIImage.sceneSprite(named: imageNamed)!
        //let playerNumber = entity.component(ofType: CharacterComponent.self)?.playerNumber ?? 0
        //let spriteNode = FLMapSprite(image: spriteImage,playerNumber:playerNumber)
        
        let character = entity.component(ofType: CharacterComponent.self)?.character
        let spriteNode = SimpleBeingNode(face: character!.avatarIcon)
        
        let movementComponent = MovementComponent(scene:scene!)
        spriteNode.entity = entity
        let island = scene!.island(named: entity.islandName!)
        let islandNode = scene!.islandFor(dungeon: island)
        entity.addComponent(movementComponent)
        entity.addComponent(GKSCNNodeComponent(node: spriteNode))
        islandNode.addChildNode(spriteNode)
        
        islandNode.dungeon.addBeing(entity: entity)
        movementComponent.placeAt(position: entity.gridPosition,inDungeon: islandNode.dungeon)
        
        
    }
    
    func otherEntities(playerNumber:Int) -> [GridEntity] {
        return self.entities.filter { (entity) -> Bool in
            let component = entity.component(ofType: CharacterComponent.self)!
            return component.playerNumber != playerNumber
        }
    }
    
    func playerEntities(playerNumber:Int) -> [GridEntity] {
        return self.entities.filter { (entity) -> Bool in
            let component = entity.component(ofType: CharacterComponent.self)!
            return component.playerNumber == playerNumber
        }
    }
    
}
