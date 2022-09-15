//
//  NotificationManager.swift
//  NPC
//

//  Created by Le Nguyen on 14/09/2022.
//

import SwiftUI

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

class NotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject{
//    //Singleton is requierd because of delegate
//    static let shared: NotificationManager = NotificationManager()
//    let notificationCenter = UNUserNotificationCenter.current()
//    
//    private override init(){
//        super.init()
//        //This assigns the delegate
//        notificationCenter.delegate = self
//    }
//    
//    func requestAuthorization() {
//        print(#function)
//        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//            if granted {
//                print("Access Granted!")
//            } else {
//                print("Access Not Granted")
//            }
//        }
//    }
//    
//    func deleteNotifications(){
//        print(#function)
//        notificationCenter.removeAllPendingNotificationRequests()
//    }
//    ///This is just a reusable form of all the copy and paste you did in your buttons. If you have to copy and paste make it reusable.
//    func scheduleTriggerNotification(title: String, body: String, categoryIdentifier: String, dateComponents : DateComponents, repeats: Bool) {
//        print(#function)
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.categoryIdentifier = categoryIdentifier
//        content.sound = UNNotificationSound.default
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        notificationCenter.add(request)
//    }
//    ///Prints to console schduled notifications
//    func printNotifications(){
//        print(#function)
//        notificationCenter.getPendingNotificationRequests { request in
//            for req in request{
//                if req.trigger is UNCalendarNotificationTrigger{
//                    print((req.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()?.description ?? "invalid next trigger date")
//                }
//            }
//        }
//    }
//    //MARK: UNUserNotificationCenterDelegate
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        
//        completionHandler(.banner)
//    }

