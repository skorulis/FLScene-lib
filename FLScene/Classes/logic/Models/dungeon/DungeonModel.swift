//
//  DungeonModel.swift
//  floatios
//
//  Created by Alexander Skorulis on 20/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import GameplayKit

public class DungeonModel: Codable {
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case overlandOffset
        case name
        case nodes
    }
    
    public let name:String
    public var nodes:[MapHexModel] = []
    public var width:Int
    public var height:Int
    public var graph:GKGraph = GKGraph([])
    public var overlandOffset:SCNVector3 = SCNVector3(0,0,0)
    
    public var size:vector_int2 {
        return vector_int2(Int32(width),Int32(height))
    }
    
    public init(width:Int,height:Int,name:String) {
        self.width = width
        self.height = height
        self.name = name
        
        let baseTerrain = ReferenceController.instance.getTerrain(type: .grass)
        
        for y in 0..<height {
            for x in 0..<width {
                nodes.append(MapHexModel(terrain: baseTerrain,position:vector_int2(Int32(x),Int32(y))))
            }
        }
        
        graph.add(nodes)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        overlandOffset = try container.decode(SCNVector3.self, forKey: .overlandOffset)
        nodes = try container.decodeIfPresent([MapHexModel].self, forKey: .nodes) ?? []
        
        graph.add(nodes)
    }
    
    public func updateConnectionGraph() {
        for node in nodes {
            node.removeAllConnections()
        }
        
        for y in 0..<height {
            for x in 0..<width {
                let node = self.nodeAt(x: x, y: y)!
                let adjacent = self.adjacentNodes(node: node).filter { $0.canPass()}
                node.addConnections(to: adjacent, bidirectional: false)
            }
        }
    }
    
    func adjacentNodes(position:vector_int2) -> [MapHexModel] {
        guard let node = self.nodeAt(vec: position) else { return []}
        return adjacentNodes(node: node)
    }
    
    func adjacentNodes(node:MapHexModel) -> [MapHexModel] {
        let x = Int(node.gridPosition.x)
        let y = Int(node.gridPosition.y)
        var nodes:[MapHexModel?] = [self.nodeAt(x: x+1, y: y),self.nodeAt(x: x-1, y: y)]
        
        nodes.append(self.nodeAt(x: x, y: y+1))
        nodes.append(self.nodeAt(x: x, y: y-1))
        if y % 2 == 1 {
            nodes.append(self.nodeAt(x: x+1, y: y+1))
            nodes.append(self.nodeAt(x: x+1, y: y-1)) //Maybe wrong
        } else {
            nodes.append(self.nodeAt(x: x-1, y: y+1))
            nodes.append(self.nodeAt(x: x-1, y: y-1)) //Maybe wrong
        }
        
        return nodes.filter { $0 != nil}.map { $0!}
    }
    
    func isDirectlyAdjacent(pos1:vector_int2,pos2:vector_int2) -> Bool {
        let adjacentNodes = self.adjacentNodes(node: nodeAt(vec: pos1)!)
        return adjacentNodes.filter { $0.gridPosition == pos2}.count > 0
    }
    
    func tryConnect(node:MapHexModel,x:Int,y:Int) {
        if let other = self.nodeAt(x: x, y: y) {
            if (other.canPass()) {
                node.addConnections(to: [other], bidirectional: false)
            }
            if (node.canPass()) {
                other.addConnections(to: [node], bidirectional: false)
            }
        }
    }
    
    public func nodeAt(point:CGPoint) -> MapHexModel? {
        return nodeAt(x: Int(point.x), y: Int(point.y))
    }
    
    public func nodeAt(vec:vector_int2) -> MapHexModel? {
        return nodeAt(x: Int(vec.x), y: Int(vec.y))
    }
    
    public func nodeAt(x:Int,y:Int) -> MapHexModel? {
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
        return node?.fixture?.ref.type
    }
    
    public func path(to:vector_int2,from:vector_int2) -> [MapHexModel] {
        guard let node = self.nodeAt(vec: to) else { return [] }
        guard let fromNode = self.nodeAt(vec: from) else { return [] }
        
        return findPath(from: fromNode, to: node)
    }
    
    public func path(to:CGPoint,from:CGPoint) -> [MapHexModel] {
        guard let node = self.nodeAt(point: to) else { return [] }
        guard let fromNode = self.nodeAt(point: from) else { return [] }
        return findPath(from: fromNode, to: node)
    }
    
    func findPath(from:MapHexModel,to:MapHexModel) -> [MapHexModel] {
        if !to.canPass() {
            return []
        }
        let missingConnections = to.connectedNodes.filter { (otherNode) -> Bool in
            return !otherNode.connectedNodes.contains(to)
        }
        
        //Add extra connections to make this node accessible
        for node in missingConnections {
            node.addConnections(to: [to], bidirectional: false)
        }
        
        let path = graph.findPath(from: from, to: to) as! [MapHexModel]
        
        //Remove additional connections
        for node in missingConnections {
            node.removeConnections(to: [to], bidirectional: false)
        }
        
        return path
    }
    
    public func addBeing(entity:GridEntity) {
        let node = self.nodeAt(x: entity.x, y: entity.y)!
        node.beings.append(entity)
    }
    
    public func removeBeing(entity:GridEntity) {
        let node = self.nodeAt(x: entity.x, y: entity.y)!
        node.beings = node.beings.filter { $0 !== entity }
    }
    
    public func allMonsters() -> [GridEntity] {
        var all:[GridEntity] = []
        for node in self.nodes {
            all.append(contentsOf: node.beings)
        }
        return all
    }
    
    public func metaData() -> [String:Any] {
        var dict = [String:Any]()
        dict[CodingKeys.name.rawValue] = name
        dict[CodingKeys.width.rawValue] = width
        dict[CodingKeys.height.rawValue] = height
        dict[CodingKeys.overlandOffset.rawValue] = overlandOffset.jsonDict()
        return dict
    }
    
    func randomEmptySquare() -> MapHexModel {
        let x = RandomHelpers.rand(max: self.width)
        let y = RandomHelpers.rand(max: self.height)
        guard let node = self.nodeAt(x: x, y: y) else { return randomEmptySquare() }
        if node.canPass() {
            return node
        } else {
            return randomEmptySquare()
        }
    }
}
