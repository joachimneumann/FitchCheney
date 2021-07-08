//
//  PhoneNotification.swift
//  Fitch Cheney
//
//  Created by Joachim Neumann on 07/07/2021.
//

import Foundation
import WatchConnectivity


class PhoneNotification: NSObject, WCSessionDelegate, ObservableObject {
    enum WatchStatus {
        case ok, unknown, error
    }
    @Published var watchStatus: WatchStatus = .error
    var session: WCSession
    var usesAppleWatch: Bool {
        return UserDefaults.standard.bool(forKey: "UsesAppleWatch")
    }

    init(session: WCSession = .default) {
        print("Phone init()")

        self.session = WCSession.default
        super.init()
        if (!WCSession.isSupported()) {
            print("Phone WCSession not supported.")
            watchStatus = .error
            print("watchStatus = \(self.watchStatus)")
        } else {
            print("Phone WCSession supported.")
            session.delegate = self
            session.activate()
        }
    }

    func send(_ c: Model.Card) {
        send(c.number.shortName+" of "+c.suit.name)
    }

    func send(_ s: String) {
        if (usesAppleWatch) {
            session.sendMessage(["Message": s], replyHandler: {
                (payload) in
                guard let reply = payload["status"] as? String else {
                    print("wrong reply from watch");
                    self.watchStatus = .error
                    print("watchStatus = \(self.watchStatus)")
                    return
                }
                print("reply from Watch: \(reply)")
                self.watchStatus = .ok
                print("watchStatus = \(self.watchStatus)")
            }) {
                (error) in
                print("error: phone sending")
                print(error.localizedDescription)
                self.watchStatus = .error
                print("watchStatus = \(self.watchStatus)")
            }
            print("phone sending: \(s)")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            print("Phone activationDidComplete with state \(activationState)")
            self.watchStatus = .unknown
            print("watchStatus = \(self.watchStatus)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.watchStatus = .unknown
            print("watchStatus = \(self.watchStatus)")
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.watchStatus = .unknown
            print("watchStatus = \(self.watchStatus)")
        }
    }
    
}
