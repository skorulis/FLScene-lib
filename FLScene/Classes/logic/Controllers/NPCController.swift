//
//  NPCController.swift
//  floatios
//
//  Created by Alexander Skorulis on 29/6/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import Foundation

public class NPCController {

    let actionController:ActionController
    let cityController:CityController
    let ref:ReferenceController
    var npcs:[NonPlayerCharacterModel] = []
    var nameGen = NameGenerator()
    
    init(actions:ActionController,city:CityController,ref:ReferenceController) {
        self.actionController = actions
        self.cityController = city;
        self.ref = ref
        
        for _ in 0...2 {
            npcs.append(makeCharacter())
        }
        
        for npc in npcs {
            self.cityController.add(occupant: npc.base)
        }
    }
    
    private func makeCharacter() -> NonPlayerCharacterModel {
        let name = nameGen.getName()
        let base = CharacterModel(name: name)
        for _ in 1...2 {
            let skill = randomSkill()
            base.addSkill(skill: skill)
        }
        
        return NonPlayerCharacterModel(base: base)
    }
    
    private func randomSkill() -> SkillModel {
        let skillRef = ref.randomSkill()
        let level = Int(arc4random_uniform(10))
        return SkillModel(type: skillRef,level:level)
    }
    
    public func dayFinished() {
        for npc in npcs {
            actionController.endDay(character: npc.base)
        }
    }
}
