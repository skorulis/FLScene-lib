//
//  SustainedActionComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/9/18.
//

import GameplayKit

class SustainedActionComponent: BaseEntityComponent {

    private var currentAction:ActionType?
    private var tickDelay:DeltaDelayTicker
    
    override init() {
        tickDelay = DeltaDelayTicker(tickFrequency: 4) //Tick every 8 seconds
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAction(action:ActionType) {
        self.currentAction = action
    }
    
    func stopAction() {
        self.currentAction = nil
        tickDelay.reset()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let currentAction = currentAction else { return }
        if !tickDelay.isTickReady(delta: seconds) {
            return
        }
        
        guard let character = self.entity?.component(ofType: CharacterComponent.self)?.character else { return }
        getResult(action: currentAction, character: character)
        
    }
    
    private func getResult(action:ActionType,character:CharacterModel) {
        let controller = ItemFinderController(ref: ReferenceController.instance)
        
        if action == .fish {
            let item = controller.findItem(attributes: [.fish])
            character.inventory.add(item: item)
            events()?.gotItem(item: item)
            print("got item \(item.ref.name)")
        }
    }
    
    override func wasAddedToManager(manager:CharacterManager) {
        events()?.actionObservers.add(object: self, {[weak self] (entity) in
            self?.stopAction()
        })
    }
    
}
