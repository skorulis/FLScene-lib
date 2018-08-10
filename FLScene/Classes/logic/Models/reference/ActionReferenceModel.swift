//
//  ActionReferenceModel.swift
//  floatios
//
//  Created by Alexander Skorulis on 9/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import Foundation
#if os(iOS)
//import FontAwesomeKit
#endif

public enum ActionType: String, Codable {
    case forage //Find food
    case mine //Find minerals
    case lumberjack //Get wood
    case sleep
    case eat //Should really be use item and be under a separate case
    case explore //Look around and find things
    case dungeon //Go into the dungeon
}

public enum RequirementType: String, Codable {
    case item
    case resource
    case skill
}

public struct RequirementModel: Codable {
    
    public let type:RequirementType
    public let identifier:String
    public let value:Int
    //public let 
    
    public static func time(value:Int) -> RequirementModel {
        return RequirementModel(type: .resource, identifier: "time", value: value)
    }
    
    public static func satiation(value:Int) -> RequirementModel {
        return RequirementModel(type: .resource, identifier: "satiation", value: value)
    }
    
    public static func item(name:String,value:Int) -> RequirementModel {
        return RequirementModel(type: .item, identifier: name, value: value)
    }
    
    public static func skill(type:SkillType,level:Int = 1) -> RequirementModel {
        return RequirementModel(type: .skill, identifier: type.rawValue, value: level)
    }
    
}

//Should be codable, but getting around that for now
public struct ActionReferenceModel {

    public let type:ActionType
    public let requirements:[RequirementModel]
    #if os(iOS)
    //public var icon:FAKIcon?
    #endif
    
    public init(type:ActionType, reqs:[RequirementModel] = []) {
        self.type = type
        self.requirements = reqs
    }
    
}
