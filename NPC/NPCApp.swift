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

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Notification stuff
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // Request authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){success,_ in
            guard success else {
                return
            }
            print ("Success in APNS registry")
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            print("Token: \(token)")
        }
    }
}

@main
struct NPCApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var routerView = RouterView()
    
    var body: some Scene {
        WindowGroup {
            // WelcomeView()
            RootView().environmentObject(routerView)
        }
    }
}
