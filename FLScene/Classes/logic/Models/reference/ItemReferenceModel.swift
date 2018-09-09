//
//  ItemReferenceModel.swift
//  floatios
//
//  Created by Alexander Skorulis on 1/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import Foundation

//Probably going to end up using this for something else, but this is good for now
struct ItemAttributes: OptionSet, Codable {
    let rawValue: Int
    
    static let fish = ItemAttributes(rawValue: 1 << 0)
}

public struct ItemReferenceModel: Codable {

    public let name:String
    public let description:String
    var attributes:ItemAttributes?
    
    init(name:String, description:String) {
        self.name = name
        self.description = description
    }
    
}
