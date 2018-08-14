//
//  MapFixtureModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/8/18.
//

public class MapFixtureModel: Codable {

    enum CodingKeys: String, CodingKey {
        case type
        case dungeon
        case node
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
        let type = try values.decode(String.self, forKey: .type)
        ref = ReferenceController.instance.getDungeonTile(type: DungeonTileType(rawValue: type)!)
    }
    
}
