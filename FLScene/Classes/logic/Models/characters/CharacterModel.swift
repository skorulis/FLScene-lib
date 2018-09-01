//
//  CharacterModel.swift
//  App
//
//  Created by Alexander Skorulis on 26/6/18.
//

import GameplayKit

final public class CharacterModel: Codable {

    public var name:String
    public var avatarIcon = "👤"
    public var spriteName = "alienPink"
    public let satiation:MaxValueField
    public let time:MaxValueField
    public var ether:Int
    public let inventory:InventoryModel
    public let skills:SkillListModel
    var location:LocationModel
    
    init(name:String="") {
        self.name = name
        satiation = MaxValueField(maxValue: 100)
        time = MaxValueField(maxValue: 100)
        ether = 100
        inventory = InventoryModel()
        skills = SkillListModel()
        location = LocationModel(gridPosition: vector_int2(0,0))
    }
    
    public func hasResource(name:String,quantity:Int) -> Bool {
        return self.resourceQuantity(name: name) >= quantity
    }
    
    public func resourceQuantity(name:String) -> Int {
        if (name == "satiation") {
            return satiation.value
        } else if (name == "time") {
            return time.value
        } else if (name == "ether") {
            return ether
        }
        return 0 //Shouldn't happen
    }
    
    public func takeResource(name:String,quantity:Int) {
        if (name == "satiation") {
            satiation -= quantity
        } else if (name == "time") {
            time -= quantity
        } else if (name == "ether") {
            ether -= quantity
        }
    }
    
    public func addResource(name:String,quantity:Int) {
        if (name == "satiation") {
            satiation += quantity
        } else if (name == "time") {
            time += quantity
        } else if (name == "ether") {
            ether += quantity
        }
    }
    
    public func addSkill(skill:SkillModel) {
        self.skills.add(skill: skill)
    }
    
    public func addXP(skill:String,quantity:Int) {
        //TODO: Add skills
    }
    
    public func hasSkill(skill:SkillType) -> Bool {
        return self.skills.skillLevel(type: skill) > 0
    }
    
}
