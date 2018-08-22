//
//  BattleAIComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit
import SKSwiftLib

class BattleAIComponent: GKComponent {

    let island:DungeonModel
    let spells:SpellManager
    
    func gridEntity() -> GridEntity {
        return self.entity as! GridEntity
    }
    
    init(island:DungeonModel,spells:SpellManager) {
        self.island = island
        self.spells = spells
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let characterComponent = self.entity?.component(ofType: CharacterComponent.self) else { return }
        guard characterComponent.hasMana(cost: 10) else { return }
        
        guard let spellCasting = self.entity?.component(ofType: SpellCastingComponent.self) else { return }
        let sprite = self.gridEntity().component(ofType: FLSpriteComponent.self)
        
        let dangerSpells = self.spells.spellsTargeting(entity: self.gridEntity())
        if dangerSpells.count > 2 {
            let adjacent = island.adjacentNodes(position:gridEntity().gridPosition).filter { $0.canPass() }
            if let node = adjacent.randomItem() {
                sprite?.moveToFull(position: node.gridPosition, island: island)
                return
            }
        }
        
        let ownNode:SCNNode = entity!.component(ofType: FLSpriteComponent.self)!.sprite
        let target = entity!.component(ofType: TargetComponent.self)!
        guard let targetEntity = target.target else { return }
        let targetNode = target.node()
        let distance = (ownNode.position - targetNode.position).magnitude()
        
        let spell = characterComponent.character.spells[0]
        if distance < spell.range() {
            spellCasting.castSpell(spell: spell)
        } else {
            sprite?.moveToFull(position: targetEntity.gridPosition, island: island)
            
        }
    }
    
}
