//
//  BridgeModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 28/8/18.
//

import Foundation
import GameplayKit

struct BridgeModel: Codable {
    
    let firstIslandName:String
    let secondIslandName:String
    
    let firstGridPosition:vector_int2
    let secondGridPosition:vector_int2
    
    func position(for island:String) -> vector_int2? {
        if island == firstIslandName {
            return firstGridPosition
        } else if island == secondIslandName {
            return secondGridPosition
        }
        return nil
    }
    
    func isFirst(island:String) -> Bool {
        return self.firstIslandName == island
    }
    
    func otherEnd(island:String) -> String {
        if island == firstIslandName {
            return secondIslandName
        } else {
            return firstIslandName
        }
    }
    
    
}
