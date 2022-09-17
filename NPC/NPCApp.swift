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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Here we actually handle the notification
        print("Notification received with identifier \(notification.request.identifier)")
        // So we call the completionHandler telling that the notification should display a banner and play the notification sound - this will happen while the app is in foreground
        completionHandler([.alert, .banner, .sound])
    }
}

@main
struct NPCApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var routerView = RouterView()
    @State var episode = Episodes(audio: "http://feedproxy.google.com/~r/wskbcast/~5/Bfv7vOn-sMI/Ep88AWatchedGoatNeverBurns.mp3", audio_length: 4638, description: "this is a description", episode_uuid: "6bf59a32de804ede9101f7ba75d12677", podcast_uuid: "0c28802a7e814a55ada3ba54847258bc", pub_date: "2017-12-07 13:59:00+00", title: "Ep88: A Watched Goat Never Burns", image: "http://is5.mzstatic.com/image/thumb/Music71/v4/f8/a3/3e/f8a33e4e-bd23-ca5d-1aa2-bdb0e6b0f74b/source/600x600bb.jpg", user_id: "", isLiked: false)
    @State var upload = Uploads(title: "Hi", description: "This is an upload", audioPath: "http://feedproxy.google.com/~r/wskbcast/~5/Bfv7vOn-sMI/Ep88AWatchedGoatNeverBurns.mp3", author: "Phuong Nguyen", pub_date: "2017-12-07 13:59:00+00", image: "http://is5.mzstatic.com/image/thumb/Music71/v4/f8/a3/3e/f8a33e4e-bd23-ca5d-1aa2-bdb0e6b0f74b/source/600x600bb.jpg", userID: "o1Ziln0o2GUWicAwK2LWmIIj1dz1", numOfLikes: 0, audio_length: 4638, userImage: "http://is5.mzstatic.com/image/thumb/Music71/v4/f8/a3/3e/f8a33e4e-bd23-ca5d-1aa2-bdb0e6b0f74b/source/600x600bb.jpg", likes: [], comments: [])
    @State var download = Downloads(audio: "", title: "", isProcessing: false)
    
    var body: some Scene {
        WindowGroup {
//            StreamingView(episode: self.$episode, upload: self.$upload, download: self.$download, state: 0)
            RootView().environmentObject(routerView)
            //BottomNavBar()
        }
    }
}
