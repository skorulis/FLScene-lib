//
//  FLSpriteComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/8/18.
//

import GameplayKit
import FLGame

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
    
    public func moveTo(position:vector_int2) {
        guard let scene = self.sprite.mapScene else {return}
        let point = scene.pointFor(position: position) + SCNVector3(0,yOffset(),0)
        let action = SCNAction.move(to: point, duration: 1)
        action.timingMode = .easeInEaseOut
        
        
        self.gridEntity().gridPosition = position
        
        self.sprite.runAction(action)
    }
    
    public func placeAt(position:vector_int2) {
        guard let scene = self.sprite.mapScene else {return}
        let point = scene.pointFor(position: position) + SCNVector3(0,yOffset(),0)
        self.sprite.position = point
        self.gridEntity().gridPosition = position
    }
    
    private func yOffset() -> CGFloat {
        return 1
    }
    
}
