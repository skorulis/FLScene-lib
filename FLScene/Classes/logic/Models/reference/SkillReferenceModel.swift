//
//  SkillReferenceModel.swift
//  floatios
//
//  Created by Alexander Skorulis on 9/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import Foundation

public enum SkillType: String, Codable {
    case foraging
    case mining
    case lumberjacking
    case endurance
    case magic
}

public struct SkillReferenceModel {

    public let name:SkillType //Should be called type
    var applyBlock: ((CharacterModel,Int) -> Void)? //The block that should be called to adjust player stats
    
    init(type:SkillType, applyBlock:((CharacterModel,Int) -> Void)? = nil) {
        self.name = type
        self.applyBlock = applyBlock
    }
    
}
