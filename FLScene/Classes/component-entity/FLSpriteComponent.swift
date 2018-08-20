//
//  FLSpriteComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/8/18.
//

import GameplayKit

public class FLSpriteComponent: GKComponent {

    public var sprite:FLMapSprite
    private(set) var isMoving:Bool = false 
    
    init(sprite:FLMapSprite) {
        self.sprite = sprite
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gridEntity() -> GridEntity {
        return self.entity! as! GridEntity
    }
    
    func moveTo(square:LandPieceNode,island:DungeonModel) {
        if self.isMoving {
            return //Have to wait until you land to move again
        }
        if square.dungeonNode.beings.count > 0 {
            return //Node is already occupied
        }
        
        let spellComponent = gridEntity().component(ofType: SpellCastingComponent.self)!
        if spellComponent.isChannelling() {
            return //Can't move while channelling
        }
        
        let movementCost:Int = 2
        let component = gridEntity().component(ofType: CharacterComponent.self)!
        if !component.hasMana(cost: movementCost) {
            return //Can't move, not enough energy
        }
        component.takeMana(amount: movementCost)
        
        let fromPoint = gridEntity().gridPosition
        let path = island.path(to: square.dungeonNode.gridPosition, from: fromPoint)
        if path.count < 2 {
            return
        }
        
        let firstPoint = path[1]
        self.moveTo(position: firstPoint.gridPosition, inDungeon: island)
    }
    
    public func moveTo(position:vector_int2,inDungeon dungeon:DungeonModel) {
        isMoving = true
        let duration:Double = 0.6
        guard let scene = self.sprite.mapScene else {return}
        let point = scene.pointFor(position: position,inDungeon: dungeon) + SCNVector3(0,yOffset(),0)
        let action = SCNAction.move(to: point, duration: duration)
        action.timingMode = .easeInEaseOut
        
        dungeon.removeBeing(entity: self.gridEntity()) //Remove from old node
        self.gridEntity().gridPosition = position
        dungeon.addBeing(entity: self.gridEntity()) //Add into new node
        
        self.sprite.runAction(action) {
            self.isMoving = false
        }
    }
    
    public func placeAt(position:vector_int2,inDungeon dungeon:DungeonModel) {
        guard let scene = self.sprite.mapScene else {return}
        let point = scene.pointFor(position: position,inDungeon: dungeon) + SCNVector3(0,yOffset(),0)
        self.sprite.position = point
        self.gridEntity().gridPosition = position
    }
    
    private func yOffset() -> CGFloat {
        return 1
    }
    
}
