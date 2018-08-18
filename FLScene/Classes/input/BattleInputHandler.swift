//
//  BattleInputHandler.swift
//  Pods
//
//  Created by Alexander Skorulis on 18/8/18.
//

public class BattleInputHandler {

    let scene:BattleScene
    
    public init(scene:BattleScene) {
        self.scene = scene
    }
    
    public func castSpell(name:String) {
        self.scene.fireSpell()
    }
    
}
