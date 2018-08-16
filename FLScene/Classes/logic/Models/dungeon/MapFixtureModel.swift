//
//  MapFixtureModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/8/18.
//

public class MapFixtureModel: Codable {

    enum CodingKeys: String, CodingKey {
        case type
        case targetIsland
        case targetPosition
    }
    
    let ref:DungeonTileReferenceModel
    
    init(ref:DungeonTileReferenceModel) {
        self.ref = ref
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ref.type.rawValue, forKey: .type)
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try values.decode(String.self, forKey: .type)
        let type = DungeonTileType(rawValue: typeString)!
        ref = ReferenceController.instance.getDungeonTile(type: type)
    }
    
    class func decode(from parent:KeyedDecodingContainer<GKHexMapNode.CodingKeys>) throws -> MapFixtureModel? {
        if !parent.contains(GKHexMapNode.CodingKeys.fixture) {
            return nil
        }
        let values = try parent.nestedContainer(keyedBy: CodingKeys.self, forKey: .fixture)
        let typeString = try values.decode(String.self, forKey: .type)
        let type = DungeonTileType(rawValue: typeString)!
        if type == .teleporter {
            return try parent.decode(TeleporterFixtureModel.self, forKey: .fixture)
        } else {
            return try parent.decode(MapFixtureModel.self, forKey: .fixture)
        }
    }
    
}
