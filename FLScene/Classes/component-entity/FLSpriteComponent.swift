//
//  FLSpriteComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/8/18.
//

import GameplayKit

class FLSpriteComponent: GKComponent {

    var sprite:ASMapSprite
    
    init(sprite:ASMapSprite) {
        self.sprite = sprite
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*func gridEntity() -> GridEntity {
        return self.entity! as! GridEntity
    }*/
    
    func moveTo(position:vector_int2) {
        guard let scene = self.sprite.mapScene else {return}
        let point = scene.pointFor(position: position) + SCNVector3(0,yOffset(),0)
        let action = SCNAction.move(to: point, duration: 1)
        action.timingMode = .easeInEaseOut
        
        
//        self.gridEntity().gridPosition = position
        
        self.sprite.runAction(action)
    }
    
    func placeAt(position:vector_int2) {
        guard let scene = self.sprite.mapScene else {return}
        let point = scene.pointFor(position: position) + SCNVector3(0,yOffset(),0)
        self.sprite.position = point
//        self.gridEntity().gridPosition = position
    }
    
    private func yOffset() -> CGFloat {
        return 1
    }
    
}
