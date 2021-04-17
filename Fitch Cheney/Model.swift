//
//  Model.swift
//  Fitch Cheney
//
//  Created by Joachim Neumann on 15/04/2021.
//

import Foundation

struct Model {
    enum Suit {
        case diamonds, hearts, spades, clubs
        var name: String {
            switch self {
            case .diamonds:
                return "diamonds"
            case .hearts:
                return "hearts"
            case .spades:
                return "spades"
            case .clubs:
                return "clubs"
            }
        }
        var color: String {
            switch self {
            case .diamonds:
                return "red"
            case .hearts:
                return "red"
            case .spades:
                return "black"
            case .clubs:
                return "black"
            }
        }
        var value: Int {
            switch self {
            case .diamonds:
                return 1
            case .hearts:
                return 2
            case .spades:
                return 3
            case .clubs:
                return 4
            }
        }
    }

    enum Number {
        case N2, N3, N4, N5, N6, N7, N8, N9, N10, NJ, NQ, NK, NA
        var name: String {
            switch self {
            case .N2:
                return "2"
            case .N3:
                return "3"
            case .N4:
                return "4"
            case .N5:
                return "5"
            case .N6:
                return "6"
            case .N7:
                return "7"
            case .N8:
                return "8"
            case .N9:
                return "9"
            case .N10:
                return "10"
            case .NJ:
                return "jack"
            case .NQ:
                return "queen"
            case .NK:
                return "king"
            case .NA:
                return "ace"
            }
        }
        var shortName: String {
            switch self {
            case .N2:
                return "2"
            case .N3:
                return "3"
            case .N4:
                return "4"
            case .N5:
                return "5"
            case .N6:
                return "6"
            case .N7:
                return "7"
            case .N8:
                return "8"
            case .N9:
                return "9"
            case .N10:
                return "10"
            case .NJ:
                return "J"
            case .NQ:
                return "Q"
            case .NK:
                return "K"
            case .NA:
                return "A"
            }
        }
        var value: Int {
            switch self {
            case .N2:
                return 20
            case .N3:
                return 30
            case .N4:
                return 40
            case .N5:
                return 50
            case .N6:
                return 60
            case .N7:
                return 70
            case .N8:
                return 80
            case .N9:
                return 90
            case .N10:
                return 100
            case .NJ:
                return 110
            case .NQ:
                return 120
            case .NK:
                return 130
            case .NA:
                return 140
            }
        }
    }

    func number(value: Int) -> Number {
        switch value {
            case 20:
                return .N2
            case 30:
                return .N3
            case 40:
                return .N4
            case 50:
                return .N5
            case 60:
                return .N6
            case 70:
                return .N7
            case 80:
                return .N8
            case 90:
                return .N9
            case 100:
                return .N10
            case 110:
                return .NJ
            case 120:
                return .NQ
            case 130:
                return .NK
            case 140:
                return .NA
            default:
                return .NA
        }
    }
    
    struct Card {
        var suit: Suit
        var number: Number
        
        func gt(_ c: Card) -> Bool {
            if self.value > c.value {
                return true
            }
            return false
        }
        
        func lt(_ c: Card) -> Bool {
            if self.value < c.value {
                return true
            }
            return false
        }

        var value: Int {
            suit.value + number.value
        }
        
        static func ==(lhs: Card, rhs: Card) -> Bool {
            return lhs.suit == rhs.suit && lhs.number == rhs.number
        }
    }
    
    mutating func calc(keyCardPosition: Int) {
        var index = -100
        var posKey = 0
        var pos1 = 1
        var pos2 = 2
        var pos3 = 3
        switch keyCardPosition {
        case 1:
            break
        case 2:
            posKey = 1
            pos1 = 0
            pos2 = 2
            pos3 = 3
        case 3:
            posKey = 2
            pos1 = 0
            pos2 = 1
            pos3 = 3
        case 4:
            posKey = 3
            pos1 = 0
            pos2 = 1
            pos3 = 2
        default: break
        }
        if cards[pos1].lt(cards[pos2]) && cards[pos1].lt(cards[pos3]) {
            // position 1: Lowest
            if cards[pos2].lt(cards[pos3]) {
                index = 10
            } else {
                index = 20
            }
        } else if cards[pos1].gt(cards[pos2]) && cards[pos1].gt(cards[pos3]) {
            // position 1: largest
            if cards[pos2].lt(cards[pos3]) {
                index = 50
            } else {
                index = 60
            }
        } else {
            // position 1: middle
            if cards[pos2].lt(cards[pos3]) {
                index = 30
            } else {
                index = 40
            }
        }

        var newIndex = cards[posKey].number.value + index
        if newIndex > 140 {
            newIndex = newIndex - 130
        }
        let endNumber = number(value: newIndex)
        solution = "\(endNumber.name)_of_\(cards[posKey].suit.name)"
    }

    
    var solution: String? = nil
    var cards: [Card] = []
        
    mutating func reset() {
        cards = []
        solution = nil
    }

    init() {
        reset()
    }

}
