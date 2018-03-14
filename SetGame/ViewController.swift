//
//  ViewController.swift
//  SetGame
//
//  Created by Brian Lee on 21/02/2018.
//  Copyright © 2018 Brian Lee. All rights reserved.
//

import UIKit

func * (lhs: String, rhs: Int) -> String {
    var output = ""
    for _ in 0..<rhs {
        output += lhs
    }
    return output
}

class ViewController: UIViewController {

    let numberOfCards = 12
    lazy var game = SetGame(numberOfCards: numberOfCards)
    let COLOR = 0, SHADE = 1, SHAPE = 2, NUMBER = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1423005164, green: 0.2032473385, blue: 0.3640691042, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
        for index in buttonCards.indices {
            buttonCards[index].layer.cornerRadius = 8.0
        }
        updateViewFromModel()
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if let index = buttonCards.index(of: sender), index < game.cardsOnTable.count {
            if game.selectedCards.contains(game.cardsOnTable[index]) {
                let _ = game.deselect(at: index)
            } else {
                game.selectCard(at: index)
            }
        }
        updateViewFromModel()
    }
    
    @IBAction func deal3Cards() {
        if game.cardsOnTable.count < buttonCards.count || game.isMatched {
            game.deal3Cards()
        } else { print("NO ROOM FOR CARDS!!")}
        updateViewFromModel()
    }
    @IBOutlet var buttonCards: [UIButton]!
    @IBOutlet weak var showMatch: UILabel!
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame(numberOfCards: numberOfCards)
//        game.usableCards.removeAll()
        updateViewFromModel()
    }
    
    @IBAction func detectSetOnTable() {
        if let indices = game.detectSetOnTable() {
            for index in indices  {
                buttonCards[index].backgroundColor = #colorLiteral(red: 0.762530148, green: 0.6354503632, blue: 0.9567423463, alpha: 1)
            }
        }
    }
    
    func updateViewFromModel() {
        var count = game.cardsOnTable.count
        for index in buttonCards.indices {
            if count > 0 {
                displayCard(at: index)
            } else {
                buttonCards[index].backgroundColor = view.backgroundColor
                buttonCards[index].setAttributedTitle(nil, for: UIControlState.normal)
            }
            count -= 1
        }
        showMatch.text = game.isMatched ? "" : "" // TODO: show GOODJOB while matching 
    }
    
    func displayCard(at index: Int) {
        let card = game.cardsOnTable[index]
        let (color, strokeWidth) = getColorAndStrokeWidth(shadeCode: card.ID[SHADE], colorCode: card.ID[COLOR])
        let pattern = getPattern(shapeCode: card.ID[SHAPE], numberCode: card.ID[NUMBER])
        let attributes: [NSAttributedStringKey:Any] = [.strokeWidth : strokeWidth, .foregroundColor : color]
        let attrString = NSAttributedString(string: pattern, attributes: attributes)
        let selected = game.selectedCards.contains(card)
        buttonCards[index].setAttributedTitle(attrString, for: UIControlState.normal)
        buttonCards[index].backgroundColor = (game.matchedCards.contains(card)) ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 0.8534074426, green: 0.8470880985, blue: 0.8582440019, alpha: 1)
        buttonCards[index].layer.borderWidth = selected ? 5.0 : 0.0
        buttonCards[index].layer.borderColor = selected ? UIColor.gray.cgColor : nil
    }

    func getColorAndStrokeWidth(shadeCode: Int, colorCode: Int) -> (color: UIColor,strokeWidth: Double) {
        var strokeWidth = -8.0
        var color = (colorCode == Card.attributeCodes[0]) ? #colorLiteral(red: 0.8000848889, green: 0.2793030143, blue: 0.39237988, alpha: 1) : (colorCode == Card.attributeCodes[1]) ? #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1) : #colorLiteral(red: 0.3148985505, green: 0.6239375472, blue: 0.4248751402, alpha: 1)
        switch shadeCode {
        case Card.attributeCodes[0]: color = color.withAlphaComponent(1.0)
        case Card.attributeCodes[1]: color = color.withAlphaComponent(0.15)
        case Card.attributeCodes[2]: color = color.withAlphaComponent(1.0) ; strokeWidth *= -1;
        default: assert(false, "<ERROR> Wrong Shade Code!!")
        }
        return (color, strokeWidth)
    }
    
    func getPattern(shapeCode: Int, numberCode: Int) -> String {
        let num = (numberCode == Card.attributeCodes[0]) ? 1 : (numberCode == Card.attributeCodes[1]) ? 2 : 3
        var output =  (shapeCode == Card.attributeCodes[0]) ? "▲\n"*num : (shapeCode == Card.attributeCodes[1]) ? "●\n"*num : "■\n"*num
        output.removeLast()
        return output
    }
}
