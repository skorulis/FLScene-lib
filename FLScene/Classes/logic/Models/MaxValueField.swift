//
//  MaxValueField.swift
//  Common
//
//  Created by Alexander Skorulis on 26/6/18.
//

public final class MaxValueField: Codable {

    public var value:Int
    public var maxValue:Int
    
    public init(maxValue:Int) {
        self.maxValue = maxValue
        self.value = maxValue
    }
    
    public func setToMax() {
        value = maxValue
    }
    
    public func set(value:Int) {
        self.value = value
    }
    
    public func add(_ amount:Int) {
        self.value = max(min(self.value + amount,self.maxValue),0)
    }
    
    public static func +=(left:MaxValueField,right:Int) {
        left.add(right)
    }
    
    public static func -=(left:MaxValueField,right:Int) {
        left.add(-right)
    }
    
    public var description:String {
        return "\(value)/\(maxValue)"
    }
    
    
}
