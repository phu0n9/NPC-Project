//
//  NPCApp.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 29/08/2022.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Configure notification local
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){success,_ in
        //            guard success else {
        //                return
        //            }
        //            print("Succesfully Allow Notification")
        //        }
        
        //        // Push Notification (Server), MessagingDelegate, UNUserNotificationCenterDelegate
        //        Messaging.messaging().delegate = self
        //        UNUserNotificationCenter.current().delegate = self
        //
        //        // Request authorization
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){success,_ in
        //            guard success else {
        //                return
        //            }
        //            print ("Success in APNS registry")
        //        }
        //        application.registerForRemoteNotifications()
        
        // Setting up cloud messaging
        Messaging.messaging().delegate = self
        
        // Setting up Notification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        return UIBackgroundFetchResult.newData
    }
    
    //    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    //        messaging.token { token, _ in
    //            guard let token = token else {
    //                return
    //            }
    //            print("Token: \(token)")
    //        }
    //    }
}

// Cloud messaging
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        UserSettings().token = fcmToken ?? ""
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
}

@main
struct NPCApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var routerView = RouterView()
    
    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(routerView)
        }
    }
}
