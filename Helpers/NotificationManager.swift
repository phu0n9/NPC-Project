//
//  NotificationManager.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 15/09/2022.
//

import Foundation
class NotificationManager : ObservableObject {
    
    func sendMessageToDevice(userToken: String) {
        guard let url = URL(string: Settings.firebaseURL) else {
            return
        }
        
        let json : [String:Any] = [
            "to": userToken,
            "notification": [
                "title" : "NPC App",
                "body": "This is a message"
            ],
            "data": [
                "hey": "hello"
            ]
        ]
        let serverKey = Settings.serverKey
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { _, _, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            print("Success")
            
        }
    }
}
