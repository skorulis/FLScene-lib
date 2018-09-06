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
    weak var characterManager:CharacterManager?
    var isPlayerAI:Bool = false
    
    func gridEntity() -> GridEntity {
        return self.entity as! GridEntity
    }
    
    init(island:DungeonModel,spells:SpellManager,characterManager:CharacterManager) {
        self.island = island
        self.spells = spells
        self.characterManager = characterManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let characterComponent = self.entity?.component(ofType: CharacterComponent.self) else { return }
        guard let spellCasting = self.entity?.component(ofType: SpellCastingComponent.self) else { return }
        guard let sprite = self.gridEntity().component(ofType: MovementComponent.self) else { return }
        
        guard let target = entity!.component(ofType: TargetComponent.self), let targetEntity = target.target else {
            findTarget()
            prepareDefense(spellCasting:spellCasting)
            return
        }
        if spellCasting.isChannelling() {
            spellCasting.stopSpell()
        }
        
        guard characterComponent.hasMana(cost: 10) else { return }
        
        if gridEntity().isBusy() {
            return //No point doing anything else
        }
        
        let danger = calculateDanger()
        if danger > 5 {
            let adjacent = island.adjacentNodes(position:gridEntity().gridPosition).filter { $0.canPass() }
            if let node = adjacent.randomItem() {
                sprite.moveToFull(position: node.gridPosition, island: island)
                return
            }
        }
        
        
        let ownNode:SCNNode = entity!.component(ofType: GKSCNNodeComponent.self)!.node
        
        let targetNode = target.node()
        let distance = (ownNode.position - targetNode.position).magnitude()
        
        let spell = characterComponent.character.spells[0]
        if distance < spell.range() {
            spellCasting.castSpell(spell: spell)
        } else {
            sprite.moveToFull(position: targetEntity.gridPosition, island: island)
            
        }
    }
    
    private func prepareDefense(spellCasting:SpellCastingComponent) {
        if !spellCasting.isChannelling() {
            if characterComponent().character.health.atMax() {
                if let buff = self.buffSpell() {
                    spellCasting.castSpell(spell: buff)
                    return
                }
            }
        }
        
        guard let heal = self.healSpell() else { return }
        if self.hasTarget() && spellCasting.isChannelling() {
            spellCasting.stopSpell()
        } else if !spellCasting.isChannelling() {
            spellCasting.castSpell(spell: heal)
        }
    }
    
    private func hasTarget() -> Bool {
        guard let target = entity!.component(ofType: TargetComponent.self) else {
            return false
        }
        return target.target != nil
    }
    
    private func findTarget() {
        guard let component = self.entity?.component(ofType: CharacterComponent.self) else { return }
        guard let newTarget = characterManager?.otherEntities(playerNumber: component.playerNumber).first else { return }
        self.gridEntity().setTarget(entity: newTarget, show: self.isPlayerAI)
    }
    
    private func healSpell() -> SpellModel? {
        return characterComponent().character.spells.filter { $0.effects.contains(.heal)}.first
    }
    
    private func buffSpell() -> SpellModel? {
        return characterComponent().character.spells.filter { $0.type == .buff}.first
    }
    
    private func characterComponent() -> CharacterComponent {
        return (self.entity?.component(ofType: CharacterComponent.self))!
    }
    
    //Calculates how dangerous the AI considers its current position
    private func calculateDanger() -> Float {
        let ownNode:SCNNode = entity!.component(ofType: GKSCNNodeComponent.self)!.node
        let ownPosition = ownNode.worldPosition
        let dangerSpells = self.spells.spellsTargeting(entity: self.gridEntity())
        let nearbySpells = dangerSpells.filter { (spell) -> Bool in
            let spellPos = spell.node().presentation.worldPosition
            return (spellPos - ownPosition).magnitude() < 3
        }
        let spellDanger = nearbySpells.map { Float($0.stats.damage) }
        return spellDanger.reduce(0,+)
    }
    
}
