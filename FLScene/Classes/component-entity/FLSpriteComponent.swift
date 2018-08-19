//
//  FLSpriteComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/8/18.
//

import GameplayKit

public class FLSpriteComponent: GKComponent {

    public var sprite:FLMapSprite
    
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
    
    public func moveTo(position:vector_int2,inDungeon dungeon:DungeonModel) {
        let duration:Double = 0.6
        guard let scene = self.sprite.mapScene else {return}
        let point = scene.pointFor(position: position,inDungeon: dungeon) + SCNVector3(0,yOffset(),0)
        let action = SCNAction.move(to: point, duration: duration)
        action.timingMode = .easeInEaseOut
        
        dungeon.removeBeing(entity: self.gridEntity()) //Remove from old node
        self.gridEntity().gridPosition = position
        dungeon.addBeing(entity: self.gridEntity()) //Add into new node
        
        self.sprite.runAction(action)
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
