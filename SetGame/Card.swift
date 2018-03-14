//
//  Card.swift
//  SetGame
//
//  Created by Brian Lee on 22/02/2018.
//  Copyright © 2018 Brian Lee. All rights reserved.
//

import Foundation

struct Card : Equatable
{
    // Index of Card Representation
//    static let SHADE = 0
//    static let SHAPE = 1
//    static let NUMBER = 2
//    static let COLOR = 3
    static let attributeCodes = [1, 10, 100]
    
    var ID: [Int]
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        let compare = lhs.ID.indices.map {lhs.ID[$0] == rhs.ID[$0]}
        return !compare.contains(false)
    }
    init(ID: [Int]) {
        assert(ID.count == 4, "4 Attributes for one card!")
        self.ID = ID
    }
}

extension Array where Element == Card {
    func isMatched() -> Bool {
        assert(self.count == 3, "[Card].isMatched() can only called when selecting 3 cards!!")
        var totalSum = [0, 0, 0, 0]
        for card in self {
            for idx in card.ID.indices {
                totalSum[idx] += card.ID[idx]
            }
        }
        let matched = totalSum.map { ($0 == Card.attributeCodes[0]*3) || ($0 == Card.attributeCodes[1]*3) || ($0 == Card.attributeCodes[2]*3) || ($0 == (Card.attributeCodes[0] + Card.attributeCodes[1] + Card.attributeCodes[2]))}
        print("*Matching: totalSum = \(totalSum)")
        return !matched.contains(false)
    }
    
    mutating func removeRandomly() -> Card {
        let randIdx = Int(arc4random_uniform(UInt32(self.count)))
        return self.remove(at: randIdx)
    }
}
