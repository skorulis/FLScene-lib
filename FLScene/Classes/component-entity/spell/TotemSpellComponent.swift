//
//  TotemSpellComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 25/8/18.
//

import GameplayKit

class TotemSpellComponent: SpellComponent {

    static private let totemHeight:CGFloat = 1.5
    
    let landNode:MapHexModel
    let cornerIndex:Int
    
    init(landNode:MapHexModel,cornerIndex:Int) {
        self.landNode = landNode
        self.cornerIndex = cornerIndex
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //Make the spell effects target who is standing on the node
        let effects = self.entity?.component(ofType: SpellEffectComponent.self)
        effects?.targetEntity = landNode.beings.first
    }
    
    class func makeNode() -> SCNNode {
        let geometry = SCNCylinder(radius: 0.2, height: CGFloat(totemHeight))
        geometry.firstMaterial = MaterialProvider.targetMaterial()
        let spellNode = SCNNode(geometry: geometry)
        return spellNode
    }
    
    class func nextCornerIndex(spells:[SpellEntity],gridPosition:vector_int2) -> Int? {
        let otherTotems = spells.filter { (currentSpell) -> Bool in
            guard let totem = currentSpell.component(ofType: TotemSpellComponent.self) else { return false }
            return totem.landNode.gridPosition == gridPosition
        }
        let usedCorners = otherTotems.map { $0.component(ofType: TotemSpellComponent.self)!.cornerIndex }
        let freeCorners = (0..<6).filter { !usedCorners.contains($0)}
        return freeCorners.first
    }
    
    func positionAtCorner(squarePosition:SCNVector3) {
        let hexMath = Hex3DMath(baseSize: 1)
        let point = hexMath.regularHexPoint(index: cornerIndex)
        let node = self.spellNode()
        
        let blockHeight = CGFloat(hexMath.height())
        let y = (TotemSpellComponent.totemHeight+blockHeight)/2
        
        node?.position = SCNVector3(point.x,y,point.y) + squarePosition
        let centreDir = SCNVector3(-point.x,0,-point.y).normalized()
        node?.position += centreDir * 0.2
    }
    
}
