//
//  QuestModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 1/9/18.
//

import Foundation

class QuestModel: Codable {

    let name:String
    let text:String
    
    init(name:String,text:String) {
        self.name = name
        self.text = text
    }
    
}
