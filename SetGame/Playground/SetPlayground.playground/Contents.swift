//: Playground - noun: a place where people can play

import UIKit

import Foundation


struct Card : Equatable
{
    // Index of Card Representation
    //    static let SHADE = 0
    //    static let SHAPE = 1
    //    static let NUMBER = 2
    //    static let COLOR = 3
    static let attrributeCodes = [0, 1, 10]
    
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
        let matched = totalSum.map { ($0 == 0) || ($0 == 3) || ($0 == 30) || ($0 == 11)}
        return !matched.contains(false)
    }
    
    mutating func removeRandomly() -> Card {
        let randIdx = Int(arc4random_uniform(UInt32(self.count)))
        return self.remove(at: randIdx)
    }
}


struct Set
{
    var matchedCards = [Card]()
    var selectedCards = [Card]()
    var cardsOnTable = [Card]()
    var usableCards: [Card]
    var isMatched = false
    
    init(numberOfCards: Int) {
        usableCards = [Card]()
        for a1 in Card.attrributeCodes {
            for a2 in Card.attrributeCodes {
                for a3 in Card.attrributeCodes {
                    for a4 in Card.attrributeCodes {
                        usableCards.append(Card(ID: [a1, a2, a3, a4]))
                    }
                }
            }
        }
        for _ in 0..<numberOfCards {
            cardsOnTable.append(usableCards.removeFirst())
        }
    }
    
    mutating func deal3Cards() {
        if isMatched {
            for card in matchedCards {
                if let index = cardsOnTable.index(of: card) {
                    cardsOnTable[index] = usableCards.removeRandomly()
                }
            }
        } else {
            cardsOnTable.append(usableCards.removeRandomly())
        }
    }
    
    mutating func selectCard(at index: Int){
        selectedCards.append(cardsOnTable[index])
        if selectedCards.count == 3 {
            isMatched = selectedCards.isMatched()
            if isMatched {
                let _ = selectedCards.map { matchedCards.append($0)}
            }
            selectedCards.removeAll()
        }
    }
    
    mutating func deselect() {
        assert(selectedCards.count > 0, "No Card is selected!")
        selectedCards.removeLast()
    }
}


var game = Set(numberOfCards: 12)
for card in game.cardsOnTable {
    print("\(card)")
}
print("---------------------\n")
game.selectCard(at: 0)
game.selectCard(at: 1)
game.deselect()
game.deselect()
game.deselect()
game.selectCard(at: 2)
for card in game.selectedCards {
    print("\(card)")
}
print(game.isMatched)
game.deal3Cards()
for card in game.cardsOnTable {
    print("\(card)")
}
