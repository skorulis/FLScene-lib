//
//  InventoryModel.swift
//  float-server
//
//  Created by Alexander Skorulis on 26/6/18.
//

public class InventoryModel: Codable {

    public var capacity:Int
    public var items:[ItemModel]
    
    public init() {
        items = []
        capacity = 5
    }
    
    public func hasItem(name:String,quantity:Int) -> Bool {
        guard let item = findItem(name: name) else { return false }
        return item.quantity >= quantity
    }
    
    public func findItem(name:String) -> ItemModel? {
        return items.filter { $0.ref.name == name}.first
    }
    
    public func consumeItem(name:String,quantity:Int)  {
        for i in 0..<items.count {
            let item = items[i]
            if (item.ref.name == name) {
                item.quantity -= quantity
                if (item.quantity <= 0) {
                    items.remove(at: i)
                }
                return
            }
        }
    }
    
    public func add(item:ItemModel) {
        if let existing = findItem(name: item.ref.name) {
            existing.quantity += item.quantity
        } else {
            items.append(item)
        }
    }
    
}
