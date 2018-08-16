//
//  SCNVector3+Codable.swift
//  Pods
//
//  Created by Alexander Skorulis on 14/8/18.
//

import SceneKit

extension SCNVector3: Codable {
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
        case z
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(z, forKey: .z)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let x = try values.decode(Float.self, forKey: .x)
        let y = try values.decode(Float.self, forKey: .y)
        let z = try values.decode(Float.self, forKey: .z)
        self.init(x, y, z)
    }
    
    public func jsonDict() -> [String:CGFloat] {
        return [CodingKeys.x.rawValue:CGFloat(x),
                CodingKeys.y.rawValue:CGFloat(y),
                CodingKeys.z.rawValue:CGFloat(z),
        ]
    }
}

extension vector_int2: Codable {
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let x = try values.decode(Int32.self, forKey: .x)
        let y = try values.decode(Int32.self, forKey: .y)
        self.init(x, y)
    }
    
}
