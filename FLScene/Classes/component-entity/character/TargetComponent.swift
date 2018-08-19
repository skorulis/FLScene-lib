//
//  TargetComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class TargetComponent: GKComponent {

    weak var target:GridEntity?
    
    init(target:GridEntity) {
        self.target = target
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func node() -> SCNNode {
        let component = target?.component(ofType: FLSpriteComponent.self)
        return component!.sprite
    }
    
}
