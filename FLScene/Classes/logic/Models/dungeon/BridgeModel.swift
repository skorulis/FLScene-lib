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
    
    let fistGridPosition:vector_int2
    let secondGridPosition:vector_int2
    
    let firstEdge:Int
    let secondEdge:Int
    
    
}
