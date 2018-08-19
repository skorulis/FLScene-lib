//
//  SpellCastingComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellCastingComponent: GKComponent {

    weak var spellManager:SpellManager!
    
    init(spellManager:SpellManager) {
        self.spellManager = spellManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func castSpell(index:Int) {
        guard let component = self.entity?.component(ofType: CharacterComponent.self) else { return }
        guard index >= 0 && index < component.character.spells.count else { return }
        let spell = component.character.spells[index]
        castSpell(spell: spell)
    }
    
    func castSpell(spell:SpellModel) {
        guard let component = self.entity?.component(ofType: CharacterComponent.self) else { return }
        guard component.hasMana(cost: spell.cost()) else { return }
        guard let playerSprite = self.entity?.component(ofType: FLSpriteComponent.self) else { return }
        
        if spell.type == .teleport {
            
        } else if spell.type == .bolt {
            guard let target = self.entity?.component(ofType: TargetComponent.self) else { return }
            
            spellManager.addSpell(spell: spell, caster: playerSprite.sprite, target: target.node())
            component.takeMana(amount: spell.cost())
        }
    }
    
}
