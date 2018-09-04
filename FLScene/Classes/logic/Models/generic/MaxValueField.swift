//
//  MaxValueField.swift
//  Common
//
//  Created by Alexander Skorulis on 26/6/18.
//

public final class MaxValueField: Codable {

    public var value:Float
    public var valueInt:Int {
        return Int(value)
    }
    public var maxValue:Int {
        didSet {
            value = min(Float(maxValue),value)
        }
    }
    
    public init(maxValue:Int) {
        self.maxValue = maxValue
        self.value = Float(maxValue)
    }
    
    public func setToMax() {
        value = Float(maxValue)
    }
    
    public func set(value:Int) {
        self.value = Float(value)
    }
    
    public func add(_ amount:Float) {
        self.value = max(min(self.value + amount,Float(self.maxValue)),0)
    }
    
    public static func +=(left:MaxValueField,right:Int) {
        left.add(Float(right))
    }
    
    public static func +=(left:MaxValueField,right:Float) {
        left.add(right)
    }
    
    public static func -=(left:MaxValueField,right:Int) {
        left.add(Float(-right))
    }
    
    public var description:String {
        return "\(value)/\(maxValue)"
    }
    
    public var fullPercentage: CGFloat {
        return CGFloat(self.value) / CGFloat(self.maxValue)
    }
    
}
