//
//  SpellCastingComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellCastingComponent: GKComponent {

    private weak var spellManager:SpellManager!
    private var channelledSpell:SpellEntity? //Spell that is being constantly channelled
    private var castingSpell:SpellEntity? //Spell that is currently being cast
    private var remainingCastTime:TimeInterval = 0
    
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
        
        if self.isCasting() {
            return //Can't cast multiple spells at once
        }
        
        var spellEntity:SpellEntity?
        if spell.type == .teleport {
            
        } else if spell.type == .bolt {
            guard let target = self.entity?.component(ofType: TargetComponent.self) else { return }
            
            spellEntity = spellManager.makeBoltSpell(spell: spell, caster: gridEntity(), target: target.node())
            component.takeMana(amount: spell.cost())
        } else if spell.type == .teleport {
            
        } else if spell.type == .totem {
            spellEntity = spellManager.makeTotemSpell(spell: spell, caster: gridEntity())
        } else {
            spellEntity = spellManager.makePersonalSpell(spell: spell, caster: gridEntity())
        }
        if spell.isChannelSpell() {
            channelledSpell = spellEntity
            spellManager.addSpellToWorld(entity: spellEntity!)
        } else {
            self.castingSpell = spellEntity
            self.remainingCastTime = spell.castingTime()
        }
        self.nextCastTime[spell.spellId] = Date().timeIntervalSince1970 + spell.cooldown()
    }
    
    func stopSpell() {
        guard let channelling = channelledSpell else { return }
        guard let component = channelling.component(ofType: SpellExpirationComponent.self) else { return }
        component.castingStopped = true
        channelledSpell = nil
    }
    
    func isCasting() -> Bool {
        return self.channelledSpell != nil || self.castingSpell != nil
    }
    
    func isSpellAvailable(spell:SpellModel) -> Bool {
        guard let lastCast = self.nextCastTime[spell.spellId] else { return true }
        return Date().timeIntervalSince1970 >= lastCast
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let castingSpell = castingSpell {
            self.remainingCastTime -= seconds
            if remainingCastTime <= 0 {
                spellManager.addSpellToWorld(entity: castingSpell)
                self.castingSpell = nil
            }
        }
    }
    
}
