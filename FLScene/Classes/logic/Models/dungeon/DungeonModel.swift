//
//  DungeonModel.swift
//  floatios
//
//  Created by Alexander Skorulis on 20/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import GameplayKit

public class DungeonModel: NSObject {
    
    public var player:PlayerCharacterModel?
    public var playerNode:DungeonCharacterEntity?
    
    public var nodes:[GKHexMapNode] = []
    public var width:Int
    public var height:Int
    public var graph:GKGraph
    public var overlandOffset:SCNVector3 = SCNVector3(0,0,0)
    
    public var size:vector_int2 {
        return vector_int2(Int32(width),Int32(height))
    }
    
    public init(width:Int,height:Int,baseTerrain:TerrainReferenceModel,player:PlayerCharacterModel?) {
        self.width = width
        self.height = height
        self.player = player
        if let p = player {
            self.playerNode = DungeonCharacterEntity(char:p.base)
        }
        
        for y in 0..<height {
            for x in 0..<width {
                nodes.append(GKHexMapNode(terrain: baseTerrain,position:vector_int2(Int32(x),Int32(y))))
            }
        }
        
        graph = GKGraph(nodes)   
    }
    
    public func updateConnectionGraph() {
        for node in nodes {
            node.removeAllConnections()
        }
        
        for y in 0..<height {
            for x in 0..<width {
                let node = self.nodeAt(x: x, y: y)!
                if !node.canPass() {
                    continue //Don't connect
                }
                tryConnect(node: node, x: x-1, y: y)
                tryConnect(node: node, x: x+1, y: y)
                if y % 2 == 1 {
                    tryConnect(node: node, x: x, y: y+1)
                    tryConnect(node: node, x: x+1, y: y+1)
                } else {
                    tryConnect(node: node, x: x-1, y: y+1)
                    tryConnect(node: node, x: x, y: y+1)
                }
            }
        }
    }
    
    func tryConnect(node:GKHexMapNode,x:Int,y:Int) {
        if let other = self.nodeAt(x: x, y: y) {
            if (!other.canPass()) {
                return //Don't connect
            }
            node.addConnections(to: [other], bidirectional: true)
        }
    }
    
    public func nodeAt(point:CGPoint) -> GKHexMapNode? {
        return nodeAt(x: Int(point.x), y: Int(point.y))
    }
    
    public func nodeAt(vec:vector_int2) -> GKHexMapNode? {
        return nodeAt(x: Int(vec.x), y: Int(vec.y))
    }
    
    public func nodeAt(x:Int,y:Int) -> GKHexMapNode? {
        if (!isInMap(x: x, y: y)) {
            return nil
        }
        let index = y * width + x
        return nodes[index]
    }
    
    public func isInMap(point:CGPoint) -> Bool {
        return isInMap(x: Int(point.x), y: Int(point.y))
    }
    
    public func isInMap(x:Int,y:Int) -> Bool {
        return x >= 0 && y >= 0 && x < width && y < height
    }
    
    public func fixture(at:CGPoint) -> DungeonTileType? {
        let node = self.nodeAt(point: at)
        return node?.fixture?.type
    }
    
    public func path(to:vector_int2,from:vector_int2) -> [GKHexMapNode] {
        guard let node = self.nodeAt(vec: to) else { return [] }
        guard let fromNode = self.nodeAt(vec: from) else { return [] }
        
        return graph.findPath(from: fromNode, to: node) as! [GKHexMapNode]
    }
    
    public func path(to:CGPoint,from:CGPoint) -> [GKHexMapNode] {
        guard let node = self.nodeAt(point: to) else { return [] }
        guard let fromNode = self.nodeAt(point: from) else { return [] }
        
        return graph.findPath(from: fromNode, to: node) as! [GKHexMapNode]
    }
    
    public func addMonster(entity:GridEntity) {
        let node = self.nodeAt(x: entity.x, y: entity.y)!
        node.beings.append(entity)
    }
    
    public func allMonsters() -> [GridEntity] {
        var all:[GridEntity] = []
        for node in self.nodes {
            all.append(contentsOf: node.beings)
        }
        return all
    }
    
}
