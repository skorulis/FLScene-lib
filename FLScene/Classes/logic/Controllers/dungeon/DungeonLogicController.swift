//
//  DungeonLogicController.swift
//  floatios
//
//  Created by Alexander Skorulis on 21/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import Foundation
import CoreGraphics

public class DungeonLogicController {

    public let dungeon:DungeonModel
    public let ref:ReferenceController
    
    public init(dungeon:DungeonModel,ref:ReferenceController) {
        self.dungeon = dungeon
        self.ref = ref
    }
    
    public func getActions(at point:CGPoint) -> [DungeonAction] {
        guard let type = dungeon.fixture(at: point) else {
            return [.examine]
        }
        let fixture = ref.getDungeonTile(type: type)
        var actions = fixture.actions
        actions.append(.examine)
        return actions
    }
}
