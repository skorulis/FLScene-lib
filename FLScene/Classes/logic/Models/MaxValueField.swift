//
//  MaxValueField.swift
//  Common
//
//  Created by Alexander Skorulis on 26/6/18.
//

public final class MaxValueField: Codable {

    public var value:Int
    public var maxValue:Int
    private var remainder:Float = 0 //Left over from any calculations
    
    public init(maxValue:Int) {
        self.maxValue = maxValue
        self.value = maxValue
    }
    
    public func setToMax() {
        value = maxValue
        self.remainder = 0
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
    
    public static func +=(left:MaxValueField,right:Float) {
        let whole = Int(right)
        left.add(whole)
        left.remainder += right - Float(whole)
        if (left.remainder > 1) {
            left.remainder -= 1
            left.add(1)
        }
    }
    
    public static func -=(left:MaxValueField,right:Int) {
        left.add(-right)
    }
    
    public var description:String {
        return "\(value)/\(maxValue)"
    }
    
    public var fullPercentage: CGFloat {
        return CGFloat(self.value) / CGFloat(self.maxValue)
    }
    
}
