//
//  BattleAIComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class BattleAIComponent: GKComponent {

    let island:DungeonModel
    
    func gridEntity() -> GridEntity {
        return self.entity as! GridEntity
    }
    
    init(island:DungeonModel) {
        self.island = island
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let characterComponent = self.entity?.component(ofType: CharacterComponent.self) else { return }
        guard characterComponent.hasMana(cost: 10) else { return }
        
        guard let spellCasting = self.entity?.component(ofType: SpellCastingComponent.self) else { return }
        
        let ownNode:SCNNode = entity!.component(ofType: FLSpriteComponent.self)!.sprite
        let target = entity!.component(ofType: TargetComponent.self)!
        guard let targetEntity = target.target else { return }
        let targetNode = target.node()
        let distance = (ownNode.position - targetNode.position).magnitude()
        
        let spell = characterComponent.character.spells[0]
        if distance < spell.range() {
            spellCasting.castSpell(spell: spell)
        } else {
            let sprite = self.gridEntity().component(ofType: FLSpriteComponent.self)
            sprite?.moveToFull(position: targetEntity.gridPosition, island: island)
            
        }
    }
    
}
