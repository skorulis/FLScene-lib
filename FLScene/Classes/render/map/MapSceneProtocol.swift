//
//  MapSceneProtocol.swift
//  Pods
//
//  Created by Alexander Skorulis on 18/8/18.
//

import SceneKit

public protocol MapSceneProtocol: class {

    func pointFor(position:vector_int2,inDungeon dungeon:DungeonModel) -> SCNVector3
    func island(named:String) -> DungeonModel
    func islandFor(dungeon:DungeonModel) -> MapIslandNode
    var bridges:BridgeContainerNode { get }
}
