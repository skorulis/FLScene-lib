//
//  BattleInputHandler.swift
//  Pods
//
//  Created by Alexander Skorulis on 18/8/18.
//

import SceneKit

public class BattleInputHandler {

    let scene:BattleScene
    let sceneView:SCNView
    
    public init(sceneView:SCNView,scene:BattleScene) {
        self.scene = scene
        self.sceneView = sceneView
    }
    
    public func castSpell(name:String) {
        if let index = Int(name) {
            self.scene.fireSpell(index: index - 1)
        }
        
    }
    
    public func tapped(point:CGPoint) {
        let options:[SCNHitTestOption : Any] = [SCNHitTestOption.rootNode:scene.islandNode]
        
        let hits = self.sceneView.hitTest(point, options: options)
        guard let first = hits.first else { return }
        guard let square = first.node.parent as? LandPieceNode else { return }
        
        if square.dungeonNode.beings.count > 0 {
            return //Node is already occupied
        }
        
        let movementCost:Int = 5
        let component = scene.playerSprite.gridEntity().component(ofType: CharacterComponent.self)!
        if !component.hasMana(cost: movementCost) {
            return //Can't move, not enough energy
        }
        component.takeMana(amount: movementCost)
        
        let fromPoint = scene.playerSprite.gridEntity().gridPosition
        let path = scene.island.path(to: square.dungeonNode.gridPosition, from: fromPoint)
        if path.count < 2 {
            return
        }
        
        let firstPoint = path[1]
        self.scene.playerSprite.moveTo(position: firstPoint.gridPosition, inDungeon: scene.island)
    }
    
    
}
