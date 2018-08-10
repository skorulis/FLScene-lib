//
//  LoreModel.swift
//  App
//
//  Created by Alexander Skorulis on 23/6/18.
//

public final class LoreModel: Codable {

    public let name: String
    public let body: String
 
    public init(name:String,body:String) {
        self.name = name;
        self.body = body;
    }
}

public final class LoreArray: Codable {
    
    public let lore:[LoreModel]
    
    public init(lore:[LoreModel]) {
        self.lore = lore
    }
    
}
