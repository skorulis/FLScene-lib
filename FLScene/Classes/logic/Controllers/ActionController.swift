//
//  ActionController.swift
//  App
//
//  Created by Alexander Skorulis on 26/6/18.
//

import SKSwiftLib

public enum ResultType {
    case item(ItemModel)
    case resource(String,Int)
    case xp(String,Int)
}


public class ActionController {

    let ref:ReferenceController
    let dayFinishObservers = ObserverSet<ActionController>()
    
    public init(ref:ReferenceController) {
        self.ref = ref
    }
    
    public func performAction(character:CharacterModel,action:ActionReferenceModel) {
        let reqs = action.requirements
        takeRequirements(reqs: reqs, character: character)
        let results = getResults(character: character, action: action)
        
        for res in results {
            switch(res) {
            case .item(let item):
                character.inventory.add(item: item)
            case .resource(let name, let quantity):
                character.addResource(name: name, quantity: quantity)
            case .xp(let skill, let quantity):
                character.addXP(skill: skill, quantity: quantity)
            }
        }
        
        if action.type == .sleep {
            dayFinishObservers.notify(parameters: self)
        }
        
    }
    
    public func hasRequirements(character:CharacterModel,action:ActionReferenceModel) -> Bool {
        let reqs = action.requirements
        return hasRequirements(character: character, requirements: reqs)
    }
    
    public func hasRequirements(character:CharacterModel,requirements:[RequirementModel]) -> Bool {
        var result = true
        for m in requirements {
            switch(m.type) {
            case .item:
                result = result && character.inventory.hasItem(name: m.identifier, quantity: m.value)
            case .resource:
                result = result && character.hasResource(name: m.identifier, quantity: m.value)
            case .skill:
                return false //TODO: No one has skills yet
            }
        }
        
        return result
    }
    
    public func takeRequirements(reqs:[RequirementModel],character:CharacterModel) {
        for m in reqs {
            switch(m.type) {
            case .item:
                character.inventory.consumeItem(name: m.identifier, quantity: m.value)
            case .resource:
                character.takeResource(name: m.identifier, quantity: m.value)
            case .skill:
                break//Nothing to be done
            }
        }
    }
    
    public func getResults(character:CharacterModel,action:ActionReferenceModel) -> [ResultType] {
        switch(action.type) {
        case .forage:
            let item = ItemModel(ref: ref.getItem(name: "Food"))
            return [ResultType.item(item)]
        case .mine:
            return [ResultType.item(ItemModel(ref: ref.getItem(name: "Minerals")))]
        case .lumberjack:
            return [ResultType.item(ItemModel(ref: ref.getItem(name: "Wood")))]
        case .eat:
            return [ResultType.resource("satiation",20)]
        default:
            return []
        }
    }
    
    public func endDay(character:CharacterModel) {
        character.time.setToMax()
        character.satiation.add(5) //Make sure you can't get stuck, may remove later
        character.ether += 10
    }
    
    public func shouldShow(action:ActionReferenceModel,character:CharacterModel) -> Bool {
        let skillReqs = action.requirements.filter { $0.type == .skill}
        return self.hasRequirements(character: character, requirements: skillReqs)
    }
    
}
