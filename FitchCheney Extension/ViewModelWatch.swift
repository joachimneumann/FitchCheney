//
//  ViewModelWatch.swift
//  ConnectivitySwiftUI WatchKit Extension
//
//  Created by Joachim Neumann on 06/07/2021.
//

import Foundation
import WatchConnectivity

class ViewModelWatch: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    @Published var messageText = "not connected"
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
        if (!WCSession.isSupported()) {
            print("Watch WCSession not supported. Activating anyway...")
        } else {
            print("Watch WCSession supported.")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch activationDidComplete \(activationState)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let m = message["Message"] as? String ?? "unknown"
        print("did receive message \(m)")
        DispatchQueue.main.async {
            self.messageText = m
        }
    }
}
