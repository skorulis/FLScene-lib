//
//  FLSpriteComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/8/18.
//

import GameplayKit
import SKSwiftLib

public class MovementComponent: BaseEntityComponent {

    private(set) var isMoving:Bool = false
    weak var mapScene:MapSceneProtocol?
    
    init(scene:MapSceneProtocol) {
        self.mapScene = scene
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToFull(position:vector_int2,island:DungeonModel) {
        if gridEntity().isBusy() {
            return //Can't move while busy
        }
        guard let dungeonNode = island.nodeAt(vec: position) else { return }
        
        let movementCost:Int = 2
        let component = gridEntity().component(ofType: CharacterComponent.self)!
        if !component.hasMana(cost: movementCost) {
            return //Can't move, not enough energy
        }
        
        let fromPoint = gridEntity().gridPosition
        if island.isDirectlyAdjacent(pos1: position, pos2: fromPoint) {
            if !dungeonNode.canPass() {
                return //Already as close as can be
            }
        }
        
        let path = island.path(to: position, from: fromPoint)
        if path.count < 2 {
            return
        }
        
        component.takeMana(amount: movementCost)
        
        let firstPoint = path[1]
        self.moveTo(position: firstPoint.gridPosition, inDungeon: island)
    }
    
    func moveOnBridge(bridge:BridgeModel,index:Int) {
        removeFromOldNode()
        guard let sprite = entity?.component(ofType: GKSCNNodeComponent.self)?.node else { return }
        let bridgeNode = (mapScene?.bridges.bridge(with: bridge))!
        if !self.isOnBridge() {
            bridgeNode.takeOwnership(node: sprite)
            gridEntity().location.islandName = nil //Take out of island
        }
        let stone = bridgeNode.stones[index]
        let position = stone.position + SCNVector3(0,yOffset(),0)

        self.animateToPoint(point: position)
    }
    
    func removeFromOldNode() {
        if let oldIslandName = gridEntity().islandName {
            let island = mapScene?.island(named: oldIslandName)
            island?.removeBeing(entity: self.gridEntity()) //Remove from old node
            gridEntity().location.islandName = nil
        }
    }
    
    private func addToCurrentNode(island:DungeonModel?) {
        gridEntity().location.islandName = island?.name
        if let island = island {
            island.addBeing(entity: self.gridEntity())
        }
    }
    
    //Should be private
    public func moveTo(position:vector_int2,inDungeon dungeon:DungeonModel) {
        guard let scene = self.mapScene else {return}
        guard let sprite = entity?.component(ofType: GKSCNNodeComponent.self)?.node else { return }
        let islandNode = scene.islandFor(dungeon: dungeon)
        let point = islandNode.topPosition(at: position) + SCNVector3(0,sprite.yOffset(),0)
        
        if isOnBridge() {
            self.currentBridge()?.releaseOwnership(node: sprite, to: islandNode)
        }
        
        removeFromOldNode()
        self.gridEntity().location.gridPosition = position
        addToCurrentNode(island: dungeon)

        dungeon.updateConnectionGraph()
        self.animateToPoint(point: point)
    }
    
    private func animateToPoint(point:SCNVector3) {
        isMoving = true
        guard let sprite = entity?.component(ofType: GKSCNNodeComponent.self)?.node else { return }
        let originalPosition = sprite.position
        
        let posChange = (point - originalPosition)
        let length = CGFloat(posChange.magnitude())
        let dir = posChange.normalized()
        
        let duration:Double = Double(length)/4
        
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addQuadCurve(to: CGPoint(x: length, y: 0.0), control: CGPoint(x: length/2, y: length/6))
        
        let bezier = Bezier(path: path)
        
        let action = SCNAction.customAction(duration: duration) { (node, time) in
            let pct = time / CGFloat(duration)
            let bezierPos = bezier.length() * pct
            guard let pos = bezier.properties(at: bezierPos)?.position else { return}
            let yMovement = SCNVector3(0,1,0) * Float(pos.y)
            
            node.position = originalPosition + (dir * Float(pos.x)) + yMovement
        }
        action.timingMode = .easeInEaseOut
        
        sprite.runAction(action) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isMoving = false
            strongSelf.entity?.component(ofType: ActionQueueComponent.self)?.consumeNext()
        }
    }
    
    public func placeAt(position:vector_int2,inDungeon dungeon:DungeonModel) {
        guard let scene = self.mapScene else {return}
        let island = scene.islandFor(dungeon: dungeon)
        let sprite = entity?.component(ofType: GKSCNNodeComponent.self)?.node
        let point = island.topPosition(at: position) + SCNVector3(0,sprite!.yOffset(),0)
        sprite?.position = point
        dungeon.removeBeing(entity: self.gridEntity())
        self.gridEntity().location.gridPosition = position
        dungeon.addBeing(entity: self.gridEntity())
        dungeon.updateConnectionGraph()
    }
    
    private func yOffset() -> CGFloat {
        return 1
    }
    
    private func currentBridge() -> BridgeNode? {
        guard let sprite = entity?.component(ofType: GKSCNNodeComponent.self)?.node else { return nil }
        return sprite.parent as? BridgeNode
    }
    
    private func isOnBridge() -> Bool {
        return self.currentBridge() != nil
    }
    
}
