//
//  BattleCharacter.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import Foundation


//This should end up merged with the main character model, but for simplicity it's separate until everything gets finalised 
class BattleCharacter: NSObject {

    var health:MaxValueField = MaxValueField(maxValue: 20)
    var mana:MaxValueField = MaxValueField(maxValue: 20)
    let playerNumber:Int
    
    var spells:[SpellModel]
    
    init(spells:[SpellModel],playerNumber:Int) {
        self.spells = spells
        self.playerNumber = playerNumber
    }
    
}
