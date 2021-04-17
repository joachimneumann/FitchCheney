//
//  MainView.swift
//  Fitch Cheney
//
//  Created by Joachim Neumann on 15/04/2021.
//

import SwiftUI

struct Number: View {
    @ObservedObject var viewModel: ViewModel
    let w: CGFloat = 0.23
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("←")
                        .font(viewModel.font)
                        .padding(.bottom, 80)
                        .padding(.top, 30)
                        .padding(.leading, 10)
                        .opacity(viewModel.numberOfCards > 0 ? 1.0 : 0.0)
                        .onTapGesture {
                            viewModel.removeCard()
                        }
                    Spacer()
                    Text("\(viewModel.localisedCard) \(viewModel.numberOfCards + 1)")
                        .font(viewModel.font)
                        .padding(.bottom, 80)
                        .padding(.top, 30)
                }
                let numberMatrix: [[Model.Number]] = [[.N2, .N3, .N4, .N5, .N6], [.N7, .N8, .N9, .N10], [.NJ, .NQ, .NK, .NA]]
                ForEach(numberMatrix, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { n in
                            VStack {
                                Text(n.shortName)
                                    .font(viewModel.font)
                                    .onTapGesture {
                                        viewModel.selectNumber(n)
                                    }
                                let underlined = viewModel.selectedNumber != nil && viewModel.selectedNumber == n
                                Rectangle()
                                    .frame(height: 10)
                                    .padding(.horizontal, 24)
                                    .padding(.top, -10)
                                    .foregroundColor(underlined ? Color.green: Color.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                        }
                        .padding(.bottom, 40)
                    }
                }
                let suits: [Model.Suit] = [.diamonds, .hearts, .spades, .clubs]
                HStack {
                    ForEach(suits, id: \.self) { s in
                        VStack {
                        Image(viewModel.suitKeyName(s))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(0)
                            .onTapGesture {
                                viewModel.selectSuit(s)
                            }
                            let underlined = viewModel.selectedSuit != nil && viewModel.selectedSuit == s
                            Rectangle()
                                .frame(height: 10)
                                .padding(.horizontal, 24)
                                .padding(.top, -10)
                                .foregroundColor(underlined ? Color.green: Color.white)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
                    }
                }
                Spacer()
            }
            .onShake {
                viewModel.reset()
            }
        }
        .padding()
    }
}

struct White: View {
    var body: some View {
        Text("")
    }
}

struct Solution: View {
    @ObservedObject var viewModel: ViewModel
    @State var flipped = false
    @State var turn90 = false
    let duration90 = 0.3
    var body: some View {
        Image((viewModel.solution != nil && self.flipped) ? viewModel.solution! : "back")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0)) // mirror effect to compenate for 3D rotation
            .rotation3DEffect(self.turn90 ? (flipped ? Angle(degrees: 180) : Angle(degrees: 90)) : Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
            .onShake {
                if !self.turn90 {
                    withAnimation(.linear(duration: duration90)) {
                        self.turn90.toggle()
                    }
                }
                if !self.flipped {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration90) {
                        withAnimation(.linear(duration: duration90)) {
                            self.flipped.toggle()
                        }
                    }
                }
            }
            .onTapGesture {
                if self.flipped {
                    viewModel.reset()
                } else {
                    if !self.turn90 {
                        withAnimation(.linear(duration: duration90)) {
                            self.turn90.toggle()
                        }
                    }
                    if !self.flipped {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration90) {
                            withAnimation(.linear(duration: duration90)) {
                                self.flipped.toggle()
                            }
                        }
                    }
                }
            }
    }
}


struct MainView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        if viewModel.whiteScreen {
            White()
        } else {
            if viewModel.solution != nil {
                Solution(viewModel: viewModel)
            } else {
                Number(viewModel: viewModel)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel:ViewModel())
    }
}

