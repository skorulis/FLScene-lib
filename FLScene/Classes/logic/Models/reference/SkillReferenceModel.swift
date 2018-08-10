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
}

public struct SkillReferenceModel: Codable {

    public let name:SkillType
    
}
