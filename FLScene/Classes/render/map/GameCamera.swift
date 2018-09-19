//
//  GameCamera.swift
//  Pods
//
//  Created by Alexander Skorulis on 20/9/18.
//

import SceneKit

public class GameCamera: SCNCamera {
    
    private let distanceBuffer:CGFloat = 0.25
    private let minDistance:CGFloat = 4
    private let maxDistance:CGFloat = 50
    
    private weak var owner:SCNNode?
    private weak var target:SCNNode?
    
    private var distanceConstraint:SCNDistanceConstraint?
    private var baseDistance:CGFloat
    
    init(owner:SCNNode) {
        self.owner = owner
        baseDistance = 8
        super.init()
        owner.camera = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints(target:SCNNode) {
        self.target = target
        let lookAt = SCNLookAtConstraint(target: target)
        lookAt.isGimbalLockEnabled = true
        distanceConstraint = SCNDistanceConstraint(target: target)
        let acceleration = SCNAccelerationConstraint()
        
        owner?.constraints = [lookAt,distanceConstraint!,acceleration]
    }
    
    func updateDistance() {
        guard let distance = distanceConstraint else { return }
        distance.minimumDistance = baseDistance
        distance.maximumDistance = baseDistance * (1 + distanceBuffer)
    }
    
    func zoom(amount:CGFloat) {
        baseDistance += (amount * baseDistance * 2)
        baseDistance = min(max(baseDistance,minDistance),maxDistance)
        updateDistance()
    }
    
}
