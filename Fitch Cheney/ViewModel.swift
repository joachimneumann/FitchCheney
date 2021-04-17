//
//  ViewModel.swift
//  Fitch Cheney
//
//  Created by Joachim Neumann on 15/04/2021.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var model: Model
    @Published var selectedNumber: Model.Number?
    @Published var selectedSuit: Model.Suit?
    @Published var whiteScreen: Bool = false

    func hasBeenSelected(_ c: Model.Number) -> Bool {
        return false
    }
    
    func suitKeyName(_ s: Model.Suit) -> String {
        if s == .diamonds { if UserDefaults.standard.integer(forKey: "KeyCardPosition") == 1 { return "\(s.name)Key"} }
        if s == .hearts   { if UserDefaults.standard.integer(forKey: "KeyCardPosition") == 2 { return "\(s.name)Key"} }
        if s == .spades   { if UserDefaults.standard.integer(forKey: "KeyCardPosition") == 3 { return "\(s.name)Key"} }
        if s == .clubs    { if UserDefaults.standard.integer(forKey: "KeyCardPosition") == 4 { return "\(s.name)Key"} }
        return s.name
    }
    
    var solution: String? {
        model.solution
    }

    var numberOfCards: Int {
        model.cards.count
    }
    
    @objc func reset() {
        self.whiteScreen = true
        withAnimation(.easeIn(duration: 2.0)) {
            self.whiteScreen = false
            model.reset()
            selectedNumber = nil
            selectedSuit = nil
        }
    }

    var localisedCard: String {
        let language = UserDefaults.standard.string(forKey: "Language")
        switch language {
        case "English":
            return "Card"
        case "German":
            return "Karte"
        case "Vietnamese":
            return "chơi bài"
        case "Spanish":
            return "Carta"
        case "Danish":
            return "Spillekort"
        default:
            return "Card"
        }
    }

    func selectNumber(_ new: Model.Number) {
        selectedNumber = new
        cardSelected()
    }

    private func cardSelected() {
        if self.selectedSuit != nil && self.selectedNumber != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.whiteScreen = true
                withAnimation(.easeIn(duration: 1.0)) {
                    self.whiteScreen = false
                    self.model.cards.append(Model.Card(suit: self.selectedSuit!, number: self.selectedNumber!))
                    self.selectedNumber = nil
                    self.selectedSuit = nil
                    if self.model.cards.count == 4 {
                        let keyCardPosition = UserDefaults.standard.integer(forKey: "KeyCardPosition")
                        self.model.calc(keyCardPosition: keyCardPosition)
                    }
                }
            }
        }
    }

    func selectSuit(_ new: Model.Suit) {
        selectedSuit = new
        cardSelected()
    }

    var bottomPaddingNumbers: CGFloat {
        get {
            -15.0
        }
    }
    
    func removeCard() {
        self.whiteScreen = true
        withAnimation(.easeIn(duration: 1.0)) {
            self.whiteScreen = false
            model.cards.removeLast()
        }
    }
    
    var font: Font {
        get {
            guard let customFont = UIFont(name: "American Typewriter", size: 50) else {
                return Font.system(size: 10)
            }
            return Font(customFont)
        }
    }

    init() {
        model = Model()
        reset()
        UserDefaults.standard.register(defaults: [String:Any]())
        NotificationCenter.default.addObserver(self,selector: #selector(reset),name: UserDefaults.didChangeNotification,object: nil)
    }
}
