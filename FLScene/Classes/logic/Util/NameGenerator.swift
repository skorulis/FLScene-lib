//
//  NameGenerator.swift
//  floatios
//
//  Created by Alexander Skorulis on 30/6/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import Foundation

public class NameGenerator {

    public init() {
        
    }
    
    let syllables:[String] = ["ter","git","ogg","bin","tar","yel","har","ong","bik","fre","dar","car","nak","bat","bar","ber","grey","tol","nob","rat","yet","bong","kim","yal","fin","gro","stu","til","kon","dol"]
    
    public func getName() -> String {
        let count = arc4random_uniform(1) + 2
        var name = ""
        for _ in 1...count {
            let index = arc4random_uniform(UInt32(syllables.count))
            name += syllables[Int(index)]
        }
        return name.capitalized
    }
    
}
