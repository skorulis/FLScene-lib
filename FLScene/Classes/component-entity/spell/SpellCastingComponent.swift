//
//  SpellCastingComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellCastingComponent: GKComponent {

    weak var spellManager:SpellManager!
    var channelledSpell:SpellEntity?
    
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
        guard let playerSprite = self.entity?.component(ofType: FLSpriteComponent.self) else { return }
        
        if self.channelledSpell != nil {
            return //Can't cast while channelling
        }
        
        var spellEntity:SpellEntity?
        if spell.type == .teleport {
            
        } else if spell.type == .bolt {
            guard let target = self.entity?.component(ofType: TargetComponent.self) else { return }
            
            spellEntity = spellManager.addSpell(spell: spell, caster: gridEntity(), target: target.node())
            component.takeMana(amount: spell.cost())
        } else {
            spellEntity = spellManager.addPersonalSpell(spell: spell, caster: gridEntity())
        }
        if spell.isChannelSpell() {
            channelledSpell = spellEntity
        }
    }
    
    func stopSpell(spell:SpellModel) {
        guard let channelling = channelledSpell else { return }
        spellManager.removeSpell(spell: channelling)
        channelledSpell = nil
    }
    
}
