//
//  CityModel.swift
//  App
//
//  Created by Alexander Skorulis on 25/6/18.
//

public class CityModel: Codable {

    public let name:String
    
    
    public var squares:[LandPlotModel]
    
    public init(name:String,squareCount:Int) {
        self.name = name;
        
        squares = []
        for _ in 0..<(squareCount) {
            squares.append(LandPlotModel())
        }
    }
    
}
