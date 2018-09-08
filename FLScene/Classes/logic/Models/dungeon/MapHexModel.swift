//
//  GKHexMapNode.swift
//  floatios
//
//  Created by Alexander Skorulis on 22/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import GameplayKit

public class MapHexModel: GKGridGraphNode, Codable {

    enum CodingKeys: String, CodingKey {
        case terrain
        case gridPosition
        case yOffset
        case fixture
        case fixtureType
    }
    
    public var terrain:TerrainReferenceModel
    public var fixture:MapFixtureModel?
    
    //Things that can move around from node to node, allows for multiple as battles can happen when they are in the same node
    public var beings:[GridEntity] = []
    //var items:[ItemModel]
    
    public var yOffset:Int = 0
    
    public init(terrain:TerrainReferenceModel,position:vector_int2) {
        self.terrain = terrain
        super.init(gridPosition:position)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(terrain.type.rawValue, forKey: .terrain)
        try container.encode(gridPosition, forKey: .gridPosition)
        try container.encode(yOffset, forKey: .yOffset)
        if let f = fixture {
            try container.encode(f, forKey: .fixture)
        }
        
    }
    
    public convenience required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let terrainType = try values.decode(String.self, forKey: .terrain)
        let terrain = ReferenceController.instance.getTerrain(type: TerrainType(rawValue: terrainType)!)
        let gridPosition = try values.decode(vector_int2.self, forKey: .gridPosition)
        self.init(terrain: terrain, position: gridPosition)
        self.yOffset = try values.decodeIfPresent(Int.self, forKey: .yOffset) ?? 0
        self.fixture = try MapFixtureModel.decode(from: values)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeAllConnections() {
        self.removeConnections(to: self.connectedNodes, bidirectional: true)
    }
    
    public func canPass() -> Bool {
        if self.terrain.type == .void || self.terrain.type == .water {
            return false
        }
        if let f = fixture {
            return f.ref.canPass
        }
        if beings.count > 0 {
            return false
        }
        return true
    }
    
    public func actions() -> [ActionType] {
        var actions = [ActionType]()
        if let fixture = fixture {
            actions.append(contentsOf: fixture.ref.actions)
        }
        if self.terrain.type == .water {
            actions.append(ActionType.fish)
        }
        
        return actions
    }
    
}
