//
//  ContentView.swift
//  FitchCheney Extension
//
//  Created by Joachim Neumann on 19/04/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModelWatch = ViewModelWatch()
    var body: some View {
        Text(viewModelWatch.messageText)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
