//
//  ItemModel.swift
//  float-server
//
//  Created by Alexander Skorulis on 26/6/18.
//

public class ItemModel: Codable {
 
    public let ref:ItemReferenceModel
    public var quantity:Int
    
    public init(ref:ItemReferenceModel,quantity:Int = 1) {
        self.ref = ref
        self.quantity = quantity
    }
    
}
