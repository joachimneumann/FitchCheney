//
//  Fitch_CheneyApp.swift
//  FitchCheney Extension
//
//  Created by Joachim Neumann on 19/04/2021.
//

import SwiftUI

@main
struct Fitch_CheneyApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
