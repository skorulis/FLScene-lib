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
    
    public func keyDown(name:String) {
        if let index = Int(name) {
            guard let spell = self.scene.playerSpell(index: index - 1) else { return }
            if spell.isChannelSpell() {
                scene.playerCastingComponent().castSpell(spell: spell)
            }
        }
    }
    
    public func keyUp(name:String) {
        if let index = Int(name) {
            guard let spell = self.scene.playerSpell(index: index - 1) else { return }
            if spell.isChannelSpell() {
                scene.playerCastingComponent().stopSpell()
            } else {
                scene.playerCastingComponent().castSpell(spell: spell)
            }
        }
    }
    
    public func tapped(point:CGPoint) {
        let options:[SCNHitTestOption : Any] = [SCNHitTestOption.rootNode:scene.islandNode]
        
        let hits = self.sceneView.hitTest(point, options: options)
        guard let first = hits.first else { return }
        guard let square = first.node.parent as? LandPieceNode else { return }
        
        if let being = square.dungeonNode.beings.first {
            let playerEntity = scene.playerEntity
            if being !== playerEntity {
                let target = playerEntity!.component(ofType: TargetComponent.self)
                target?.target = being
            }
            return
        }
        let playerSprite = scene.playerEntity.component(ofType: MovementComponent.self)
        playerSprite?.moveToFull(position: square.dungeonNode.gridPosition, island: scene.island)
    }
    
    
}
