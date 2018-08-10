//
//  SkillModel.swift
//  Common
//
//  Created by Alexander Skorulis on 25/6/18.
//

public class SkillModel:Codable {

    public let type:SkillReferenceModel
    public var level:Int
    public var xp:Float
    
    public init(type:SkillReferenceModel,level:Int = 0) {
        self.type = type;
        self.level = level
        self.xp = 0
    }
    
}

public class SkillListModel:Codable {
    
    public var skills:[SkillModel]
    
    init(skills:[SkillModel] = []) {
        self.skills = skills
    }
    
    public func add(skill:SkillModel) {
        if findSkill(type: skill.type.name) == nil {
            skills.append(skill)
        }
    }
    
    public func findSkill(type:SkillType) -> SkillModel? {
        return self.skills.filter { $0.type.name == type}.first
    }
    
    public func skillLevel(type:SkillType) -> Int {
        return findSkill(type: type)?.level ?? 0
    }
    
    public func train(skill:SkillModel) {
        if let existing = findSkill(type: skill.type.name) {
            existing.level += 1
        } else {
            let modelNew = SkillModel(type: skill.type,level: 1)
            add(skill: modelNew)
        }
    }
    
    public func trainable(into:SkillListModel) -> SkillListModel {
        let skills = self.skills.filter { (skill) -> Bool in
            return into.skillLevel(type: skill.type.name) < skill.level
        }
        return SkillListModel(skills: skills)
    }
    
}
