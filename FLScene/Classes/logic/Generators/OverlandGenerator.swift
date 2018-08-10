//
//  OverlandGeneratorModel.swift
//  Pods
//
//  Created by Alexander Skorulis on 11/8/18.
//

import SceneKit

public class OverlandGenerator: NSObject {

    let game = GameController.instance
    let overland:FullOverlandModel
    
    public override init() {
        overland = FullOverlandModel(player:game.player.player)
    }
    
    public func baseOverland() -> FullOverlandModel {
        
        let gen1 = DungeonGenerator(size: 7, ref: game.reference, player: game.player.player)
        let gen2 = DungeonGenerator(size: 7, ref: game.reference, player: nil)
        
        let dun1 = gen1.generateDungeon(type: .outdoors)
        let dun2 = gen2.generateDungeon(type: .outdoors)
        dun2.overlandOffset = SCNVector3(15,0,15)
        overland.dungeons = [dun1,dun2]
        
        connect(dungon1: dun1, dungeon2: dun2, p1: vector_int2(4,4), p2: vector_int2(3,3))
        
        return overland
    }
    
    func connect(dungon1:DungeonModel,dungeon2:DungeonModel,p1:vector_int2,p2:vector_int2) {
        let ref = game.reference.getDungeonTile(type: .teleporter)
        
        let node1 = dungon1.nodeAt(vec: p1)!
        let node2 = dungeon2.nodeAt(vec: p2)!
        node1.fixture = TeleporterFixtureModel(ref: ref, dungeon: dungeon2, node: node2)
        node2.fixture = TeleporterFixtureModel(ref: ref, dungeon: dungon1, node: node1)
        
    }
    
}
