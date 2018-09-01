//
//  NonPlayerCharacterModel.swift
//  Common
//
//  Created by Alexander Skorulis on 25/6/18.
//

import Foundation

final class NonPlayerCharacterModel: Codable {

    let base:CharacterModel
    let id:String = NSUUID().uuidString
    var backStory:String = ""
    
    convenience init() {
        self.init(base: CharacterModel())
    }
    
    init(base:CharacterModel) {
        self.base = base
    }
    
}
