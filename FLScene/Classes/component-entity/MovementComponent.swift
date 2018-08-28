//
//  FLSpriteComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 7/8/18.
//

import GameplayKit

public class MovementComponent: GKComponent {

    private(set) var isMoving:Bool = false
    weak var mapScene:MapSceneProtocol?
    
    init(scene:MapSceneProtocol) {
        self.mapScene = scene
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gridEntity() -> GridEntity {
        return self.entity! as! GridEntity
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
    
    
    //Should be private
    public func moveTo(position:vector_int2,inDungeon dungeon:DungeonModel) {
        isMoving = true
        let duration:Double = 0.6
        guard let scene = self.mapScene else {return}
        guard let sprite = entity?.component(ofType: GKSCNNodeComponent.self)?.node else { return }
        let island = scene.islandFor(dungeon: dungeon)
        let originalPosition = sprite.position
        let point = island.topPosition(at: position) + SCNVector3(0,yOffset(),0)
        let posChange = (point - originalPosition)
        //let dir = (point - originalPosition).normalized()
        //let length = (point - originalPosition).magnitude()
        
        dungeon.removeBeing(entity: self.gridEntity()) //Remove from old node
        self.gridEntity().gridPosition = position
        dungeon.addBeing(entity: self.gridEntity()) //Add into new node
        
        let action = SCNAction.customAction(duration: duration) { (node, time) in
            let pct = time / CGFloat(duration)
            node.position = originalPosition + (posChange * Float(pct))
        }
        action.timingMode = .easeInEaseOut
        
        sprite.runAction(action) {
            self.isMoving = false
        }
        dungeon.updateConnectionGraph()
    }
    
    public func placeAt(position:vector_int2,inDungeon dungeon:DungeonModel) {
        guard let scene = self.mapScene else {return}
        let island = scene.islandFor(dungeon: dungeon)
        let point = island.topPosition(at: position) + SCNVector3(0,yOffset(),0)
        let sprite = entity?.component(ofType: GKSCNNodeComponent.self)?.node
        sprite?.position = point
        dungeon.removeBeing(entity: self.gridEntity())
        self.gridEntity().gridPosition = position
        dungeon.addBeing(entity: self.gridEntity())
        dungeon.updateConnectionGraph()
    }
    
    private func yOffset() -> CGFloat {
        return 1
    }
    
}
