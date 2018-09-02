//
//  SkillModel.swift
//  Common
//
//  Created by Alexander Skorulis on 25/6/18.
//

public class SkillModel:Codable {

    enum CodingKeys: String, CodingKey {
        case type
        case level
        case xp
    }
    
    public let ref:SkillReferenceModel
    public var level:Int
    public var xp:Float
    
    public init(ref:SkillReferenceModel,level:Int = 0) {
        self.ref = ref;
        self.level = level
        self.xp = 0
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(SkillType.self, forKey:.type)
        self.ref = ReferenceController.instance.getSkill(type: type)
        self.level = try container.decode(Int.self,forKey:.level)
        self.xp = try container.decodeIfPresent(Float.self, forKey: .xp) ?? 0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.ref.name, forKey: .type)
        try container.encode(self.level, forKey: .level)
        try container.encode(self.xp, forKey: .xp)
    }
    
}

public class SkillListModel:Codable {
    
    public var skills:[SkillModel]
    
    init(skills:[SkillModel] = []) {
        self.skills = skills
    }
    
    public func set(type:SkillType,level:Int) {
        let ref = ReferenceController.instance.getSkill(type: type)
        let model = SkillModel(ref: ref, level: level)
        if let existing = findSkill(type: type) {
            existing.level = level
        } else {
            add(skill:model)
        }
        
    }
    
    public func add(skill:SkillModel) {
        if findSkill(type: skill.ref.name) == nil {
            skills.append(skill)
        }
    }
    
    public func findSkill(type:SkillType) -> SkillModel? {
        return self.skills.filter { $0.ref.name == type}.first
    }
    
    public func skillLevel(type:SkillType) -> Int {
        return findSkill(type: type)?.level ?? 0
    }
    
    public func train(skill:SkillModel) {
        if let existing = findSkill(type: skill.ref.name) {
            existing.level += 1
        } else {
            let modelNew = SkillModel(ref: skill.ref,level: 1)
            add(skill: modelNew)
        }
    }
    
    public func trainable(into:SkillListModel) -> SkillListModel {
        let skills = self.skills.filter { (skill) -> Bool in
            return into.skillLevel(type: skill.ref.name) < skill.level
        }
        return SkillListModel(skills: skills)
    }
    
    public class func defaultSkills() -> SkillListModel {
        let skills = SkillListModel()
        skills.set(type: .endurance, level: 1)
        return skills
    }
    
}
