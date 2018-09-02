//
//  CharacterModel.swift
//  App
//
//  Created by Alexander Skorulis on 26/6/18.
//

import GameplayKit

final public class CharacterModel: Codable {

    enum CodingKeys: String, CodingKey {
        case name
        case avatarIcon
        case spriteName
        case location
        case ether
    }
    
    public var name:String
    public var avatarIcon = "👤"
    public var spriteName = "alienPink"
    public let satiation:MaxValueField
    public let time:MaxValueField
    public var ether:Int
    public let inventory:InventoryModel
    public var skills:SkillListModel
    var location:LocationModel
    
    //Battle 
    var spells:[SpellModel] = []
    var health:MaxValueField = MaxValueField(maxValue: 20)
    var mana:MaxValueField = MaxValueField(maxValue: 20)
    var playerNumber:Int = 0
    var killCount:Int = 0
    var deathCount:Int = 0
    
    public init(name:String="") {
        self.name = name
        satiation = MaxValueField(maxValue: 100)
        time = MaxValueField(maxValue: 100)
        ether = 100
        inventory = InventoryModel()
        skills = SkillListModel()
        location = LocationModel(gridPosition: vector_int2(0,0))
        let spell = ReferenceController.instance.namedSpells["minor bolt"]!
        spells.append(spell)
        updateStats()
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        spriteName = try container.decode(String.self, forKey: .spriteName)
        location = try container.decode(LocationModel.self, forKey: .location)
        avatarIcon = try container.decode(String.self, forKey: .avatarIcon)
        ether = try container.decodeIfPresent(Int.self, forKey: .ether) ?? 100
        satiation = MaxValueField(maxValue: 100)
        time = MaxValueField(maxValue: 100)
        inventory = InventoryModel()
        skills = SkillListModel()
        updateStats()
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
        updateStats()
    }
    
    public func addXP(skill:String,quantity:Int) {
        //TODO: Add skills
    }
    
    public func hasSkill(skill:SkillType) -> Bool {
        return self.skills.skillLevel(type: skill) > 0
    }
    
    func updateStats() {
        self.health.maxValue = 10 //Base 10 health
        self.mana.maxValue = 10 //Base 10 mana
        for skill in self.skills.skills {
            if let apply = skill.ref.applyBlock {
                apply(self,skill.level)
            }
        }
        
        self.health.setToMax()
        self.mana.setToMax()
    }
    
}
