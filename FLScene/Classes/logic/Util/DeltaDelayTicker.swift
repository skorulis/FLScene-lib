//
//  DeltaDelayTicker.swift
//  Pods
//
//  Created by Alexander Skorulis on 9/9/18.
//

import Foundation

class DeltaDelayTicker {

    private let tickFrequency:TimeInterval
    private var current:TimeInterval
    
    init(tickFrequency:TimeInterval) {
        self.tickFrequency = tickFrequency
        current = 0
    }
    
    func isTickReady(delta:TimeInterval) -> Bool {
        current += delta
        if current >= tickFrequency {
            current -= tickFrequency
            return true
        }
        return false
    }
    
    func reset() {
        current = 0
    }
    
}
