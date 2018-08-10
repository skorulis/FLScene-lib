//
//  CityController.swift
//  Common
//
//  Created by Alexander Skorulis on 25/6/18.
//

public class CityController  {

    public let city:CityModel
    public var occupants:[CharacterModel] = []
    
    public init() {
        city = CityModel(name: "Obl", squareCount:10)
    }
    
    public func add(occupant:CharacterModel) {
        occupants.append(occupant)
    }
    
    func dayFinished() {
        
    }
    
    
}
