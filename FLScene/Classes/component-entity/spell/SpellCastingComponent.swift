//
//  SpellCastingComponent.swift
//  Pods
//
//  Created by Alexander Skorulis on 19/8/18.
//

import GameplayKit

class SpellCastingComponent: GKComponent {

    private weak var spellManager:SpellManager!
    private var channelledSpell:SpellEntity? //Spell that is being constantly channelled
    private var castingSpell:SpellEntity? //Spell that is currently being cast
    private var remainingCastTime:TimeInterval = 0
    private var fullCastTime:TimeInterval = 0
    private var castingParticlSystem:SCNParticleSystem
    
    private var nextCastTime:[String:TimeInterval] = [:]
    let calc:SpellCalcuator = SpellCalcuator()
    private let castProgressNode:SCNNode
    
    init(spellManager:SpellManager) {
        self.spellManager = spellManager
        castingParticlSystem = SCNParticleSystem.flSystem(named: "trail")!
        let shape = SCNCylinder(radius: 0.8, height: 0.05)
        shape.firstMaterial = MaterialProvider.healthBarMaterial()
        castProgressNode = SCNNode(geometry: shape)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gridEntity() -> GridEntity {
        return self.entity as! GridEntity
    }
    
    func castSpell(spell:SpellModel) {
        guard let component = self.entity?.component(ofType: CharacterComponent.self) else { return }
        let cost = calc.spellCost(spell: spell)
        guard component.hasMana(cost: cost) else { return }
        
        if gridEntity().isBusy() {
            return //Entity is already doing something
        }
        
        if !self.isSpellAvailable(spell: spell) {
            return //Have to wait for cooldown
        }
        
        var spellEntity:SpellEntity?
        if spell.type == .teleport {
            
        } else if spell.type == .bolt {
            guard let target = self.entity?.component(ofType: TargetComponent.self) else { return }
            
            spellEntity = spellManager.makeBoltSpell(spell: spell, caster: gridEntity(), target: target.node())
            component.takeMana(amount: cost)
        } else if spell.type == .teleport {
            
        } else if spell.type == .totem {
            spellEntity = spellManager.makeTotemSpell(spell: spell, caster: gridEntity())
        } else if spell.type == .channel {
            spellEntity = spellManager.makePersonalSpell(spell: spell, caster: gridEntity())
        } else if spell.type == .buff {
            spellEntity = spellManager.makePersonalSpell(spell: spell, caster: gridEntity())
        }
        if spell.isChannelSpell() {
            channelledSpell = spellEntity
            spellManager.addSpellToWorld(entity: spellEntity!)
        } else {
            self.castingSpell = spellEntity
            self.fullCastTime = calc.castingTime(spell: spell)
            self.remainingCastTime = fullCastTime
            self.castProgressNode.isHidden = false
            let node = gridEntity().component(ofType: GKSCNNodeComponent.self)?.node
            node?.addParticleSystem(castingParticlSystem)
        }
        self.nextCastTime[spell.spellId] = Date().timeIntervalSince1970 + spell.cooldown()
    }
    
    func stopSpell() {
        guard let channelling = channelledSpell else { return }
        guard let component = channelling.component(ofType: SpellExpirationComponent.self) else { return }
        component.castingStopped = true
        channelledSpell = nil
    }
    
    func isChannelling() -> Bool{
        return self.channelledSpell != nil
    }
    
    func isCasting() -> Bool {
        return self.channelledSpell != nil || self.castingSpell != nil
    }
    
    func isSpellAvailable(spell:SpellModel) -> Bool {
        guard let lastCast = self.nextCastTime[spell.spellId] else { return true }
        return Date().timeIntervalSince1970 >= lastCast
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let castingSpell = castingSpell {
            self.remainingCastTime -= seconds
            let pctCast = (fullCastTime - self.remainingCastTime) / fullCastTime
            self.castProgressNode.scale = SCNVector3(pctCast,pctCast,pctCast)
            if remainingCastTime <= 0 {
                if castingSpell.model.type == .buff {
                    let character = entity?.component(ofType: CharacterComponent.self)
                    let buff = calc.generateBuff(spell: castingSpell.model)
                    character?.addBuff(buff: buff)
                } else {
                    spellManager.addSpellToWorld(entity: castingSpell)
                }
                
                self.castingSpell = nil
                let spriteComponent = gridEntity().component(ofType: GKSCNNodeComponent.self)!
                spriteComponent.node.removeParticleSystem(castingParticlSystem)
                castProgressNode.isHidden = true
            }
        }
    }
    
    override func didAddToEntity() {
        let node = entity?.component(ofType: GKSCNNodeComponent.self)?.node
        node!.addChildNode(castProgressNode)
        castProgressNode.position = node!.basePosition()
        castProgressNode.isHidden = true
        calc.character = entity?.component(ofType: CharacterComponent.self)?.character
    }
    
    override func willRemoveFromEntity() {
        castProgressNode.removeFromParentNode()
    }
    
}
