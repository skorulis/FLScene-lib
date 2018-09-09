//
//  ItemFinderController.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/9/18.
//

import Foundation

class ItemFinderController: NSObject {

    let ref:ReferenceController
    
    init(ref:ReferenceController) {
        self.ref = ref
    }
    
    func findItem(attributes:ItemAttributes) -> ItemModel {
        
        let itemRef = ref.itemsArray.filter { $0.attributes?.contains(attributes) ?? false }.first!
        return ItemModel(ref: itemRef)
    }
    
}
