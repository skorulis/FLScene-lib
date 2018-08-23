//
//  SpellCastingComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellCastingComponent: GKComponent {

    private weak var spellManager:SpellManager!
    private var channelledSpell:SpellEntity?
    
    private var nextCastTime:[String:TimeInterval] = [:]
    
    init(spellManager:SpellManager) {
        self.spellManager = spellManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gridEntity() -> GridEntity {
        return self.entity as! GridEntity
    }
    
    func castSpell(spell:SpellModel) {
        guard let component = self.entity?.component(ofType: CharacterComponent.self) else { return }
        guard component.hasMana(cost: spell.cost()) else { return }
        
        let spriteComponent = gridEntity().component(ofType: FLSpriteComponent.self)!
        if spriteComponent.isMoving {
            return //Can't cast while moving
        }
        
        if !self.isSpellAvailable(spell: spell) {
            return //Have to wait for cooldown
        }
        
        if self.isChannelling() {
            return //Can't cast while channelling
        }
        
        var spellEntity:SpellEntity?
        if spell.type == .teleport {
            
        } else if spell.type == .bolt {
            guard let target = self.entity?.component(ofType: TargetComponent.self) else { return }
            
            spellEntity = spellManager.addSpell(spell: spell, caster: gridEntity(), target: target.node())
            component.takeMana(amount: spell.cost())
        } else if spell.type == .teleport {
            
        } else {
            spellEntity = spellManager.addPersonalSpell(spell: spell, caster: gridEntity())
        }
        if spell.isChannelSpell() {
            channelledSpell = spellEntity
        }
        self.nextCastTime[spell.spellId] = Date().timeIntervalSince1970 + spell.cooldown()
    }
    
    func stopSpell(spell:SpellModel) {
        guard let channelling = channelledSpell else { return }
        spellManager.removeSpell(spell: channelling)
        channelledSpell = nil
    }
    
    func isChannelling() -> Bool {
        return self.channelledSpell != nil
    }
    
    func isSpellAvailable(spell:SpellModel) -> Bool {
        guard let lastCast = self.nextCastTime[spell.spellId] else { return true }
        return Date().timeIntervalSince1970 >= lastCast
    }
    
}