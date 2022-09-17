//
//  ContentView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 29/08/2022.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
//    @ObservedObject var userViewModel = UserViewModel()
//    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        VStack {
        Button("Allow notification") {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {success, _ in
                guard success else {
                    return
                }
                print("All Sets")
            }
        }
        Button("Schedule notification") {
            let content = UNMutableNotificationContent()
            content.title = "Feed the cat"
            content.subtitle = "It looks hungry"
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
//        Text("Hello, world!")
//            .padding()
//            .onAppear {
//                DispatchQueue.main.async {
//                    for value in 0..<9 {
//                        self.userViewModel.addWatchList(watchItem: Episodes(audio: "hi", audio_length: 100, description: "hi", episode_uuid: String(value), podcast_uuid: "hi", pub_date: "2022/09/09", title: "hi", image: "hi", user_id: self.userSettings.uuid, isLiked: false))
//                    }
//                }
//            }
        }
    }
    
    // Test
    private func allowShowNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {success, _ in
            guard success else {
                return
            }
            print("All Sets")
        }
    }
    
    private func showNotificationWhenLogin() {
        let content = UNMutableNotificationContent()
        content.title = "Welcome back"
        content.subtitle = "Hello User"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
