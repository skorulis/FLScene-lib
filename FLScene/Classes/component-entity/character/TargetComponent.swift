//
//  TargetComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class TargetComponent: GKComponent {

    weak var target:GridEntity? {
        didSet {
            updateTargetRing()
        }
    }
    
    var showTarget:Bool = false {
        didSet {
            updateTargetRing()
        }
    }
    
    private var targetRing:SCNNode?
    
    init(target:GridEntity) {
        self.target = target
        super.init()
        updateTargetRing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func node() -> SCNNode {
        let component = target?.component(ofType: FLSpriteComponent.self)
        return component!.sprite
    }
    
    func updateTargetRing() {
        if targetRing == nil {
            let geometry = SCNTorus(ringRadius: 1, pipeRadius: 0.1)
            geometry.firstMaterial = MaterialProvider.targetMaterial()
            targetRing = SCNNode(geometry: geometry)
        }
        
        if self.target == nil || !self.showTarget {
            targetRing?.removeFromParentNode()
        } else {
            self.node().parent!.addChildNode(targetRing!)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if self.target != nil {
            self.targetRing?.position = self.node().position - SCNVector3(0,0.8,0)
        }
    }
    
}
