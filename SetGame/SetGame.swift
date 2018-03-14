//
//  Set.swift
//  SetGame
//
//  Created by Brian Lee on 22/02/2018.
//  Copyright © 2018 Brian Lee. All rights reserved.
//

import Foundation

struct SetGame
{
    var matchedCards = [Card]()
    var selectedCards = [Card]()
    var cardsOnTable = [Card]()
    var usableCards: [Card]
    var isMatched = false
    
    init(numberOfCards: Int) {
        usableCards = [Card]()
        for a1 in Card.attributeCodes {
            for a2 in Card.attributeCodes {
                for a3 in Card.attributeCodes {
                    for a4 in Card.attributeCodes {
                        usableCards.append(Card(ID: [a1, a2, a3, a4]))
                    }
                }
            }
        }
        for _ in 0..<numberOfCards {
            cardsOnTable.append(usableCards.removeRandomly())
        }
    }
    
    mutating func deal3Cards() {
        if usableCards.count > 0 {
            if isMatched {
                isMatched = false
                for card in matchedCards {
                    if let index = cardsOnTable.index(of: card) {
                        if cardsOnTable.count > 12 {
                            cardsOnTable.remove(at: index)
                        } else {
                            cardsOnTable[index] = usableCards.removeRandomly()
                        }
                    }
                }
            } else {
                for _ in 0..<3 {
                    cardsOnTable.append(usableCards.removeRandomly())
                }
            }
        } else {
            print("NO USABLE CARDS!!")
            let cardsToRemoved = cardsOnTable.filter { matchedCards.contains($0)}
            let _ = cardsToRemoved.map {cardsOnTable.remove(at: cardsOnTable.index(of: $0)!)}
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
            print("REMOVE ALL SELECTED CARDS DONE!")
        }
    }
    
    mutating func deselect(at index: Int) -> Card?{
        if selectedCards.count > 0 {
            if let idx = selectedCards.index(of: cardsOnTable[index]) {
                return selectedCards.remove(at: idx)
            }
        }
        print("Deselect Card Fail!!")
        return nil
    }
    
    func detectSetOnTable() -> [Int]? {
        for idx1 in cardsOnTable.indices {
            for idx2 in cardsOnTable.indices {
                if idx1 == idx2 { continue }
                for idx3 in cardsOnTable.indices {
                    if idx2 == idx3 { continue }
                    if [cardsOnTable[idx1], cardsOnTable[idx2], cardsOnTable[idx3]].isMatched() {
                        return [idx1, idx2, idx3]
                    }
                }
            }
        }
        return nil
    }
}

