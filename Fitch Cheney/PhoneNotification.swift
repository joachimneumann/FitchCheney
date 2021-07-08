//
//  PhoneNotification.swift
//  Fitch Cheney
//
//  Created by Joachim Neumann on 07/07/2021.
//

import Foundation
import WatchConnectivity


class PhoneNotification: NSObject, WCSessionDelegate {
    @Published var messageText = ""
    var session: WCSession
    var usesAppleWatch: Bool {
        return UserDefaults.standard.bool(forKey: "UsesAppleWatch")
    }

    init(session: WCSession = .default) {
        print("Phone init()")

        self.session = WCSession.default
        super.init()
        if (!WCSession.isSupported()) {
            print("Phone WCSession not supported. Activating anyway...")
        } else {
            print("Phone WCSession supported.")
        }
        session.delegate = self
        session.activate()
    }

    func send(_ c: Model.Card) {
        let m = c.number.shortName+" of "+c.suit.name
        session.sendMessage(["Message": m], replyHandler: nil) {
            (error) in print(error.localizedDescription)
            print("phone sending: errorHandler")
        }
        print("phone sending: \(m)")
    }

    func send(_ s: String) {
        if (usesAppleWatch) {
            session.sendMessage(["Message": s], replyHandler: nil) {
                (error) in print(error.localizedDescription)
                print("phone sending: errorHandler")
            }
            print("phone sending: \(s)")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            print("Phone activationDidComplete with state \(activationState)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.messageText = "Phone did become inactive"
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.messageText = "Phone did deactivate"
        }
    }
    
}
