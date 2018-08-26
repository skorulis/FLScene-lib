//
//  GameController.swift
//  App
//
//  Created by Alexander Skorulis on 26/6/18.
//


public class GameController {

    public static let instance = GameController()
    
    public let action:ActionController;
    public let player:PlayerCharacterController;
    public let city:CityController;
    public let npc:NPCController
    public let reference:ReferenceController
    public let majorState:MajorStateController
    
    public init() {
        reference = ReferenceController.instance
        action = ActionController(ref:reference)
        city = CityController()
        player = PlayerCharacterController(actions: action,city:city)
        npc = NPCController(actions: action,city:city,ref:reference)
        
        majorState = MajorStateController(player:player)
        
        action.dayFinishObservers.add(object:self) {[unowned self] (controller) in
            self.city.dayFinished()
            self.player.dayFinished()
            self.npc.dayFinished()
        }
        
    }
    
}
