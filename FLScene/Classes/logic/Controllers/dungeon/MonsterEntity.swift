//
//  MonsterEntity.swift
//  floatios
//
//  Created by Alexander Skorulis on 29/7/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//


public class MonsterEntity: GridEntity {

    public let ref:MonsterReferenceModel
    
    public init(ref:MonsterReferenceModel) {
        self.ref = ref
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
