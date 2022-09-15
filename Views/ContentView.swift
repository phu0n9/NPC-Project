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
    @State var isOn: Bool = false
    let notificationManager: NotificationManager = NotificationManager.shared
    
    var body: some View {
        VStack{
        Button("Allow notification"){
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){success,_ in
                guard success else {
                    return
                }
                print ("All Sets")
            }
        }.padding()

            
        Button("Schedule notification"){
            let content = UNMutableNotificationContent()
            content.title = "You have succesfully login"
            content.subtitle = "Navigate to your profile page to complete profile"
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
            print ("Trigger notification")
        }
            
            Toggle(isOn: $isOn, label: {
                        Text("Notifications?")
                    })

                    /// change!
                    .onChange(of: isOn, perform: { toggleIsOn in
                        if toggleIsOn {
                            var dateComponents = DateComponents()
                            dateComponents.hour = 8
                                                dateComponents.minute = 5
                            self.notificationManager.scheduleTriggerNotification(title: "Morning Time", body: "Wake Up And Be Productive!", categoryIdentifier: "reminder", dateComponents: dateComponents, repeats: true)
                            print("schedule notification")
                        } else {
                            print("don't schedule notification")
                        }
                    }
                    )
            
    
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
    func allowShowNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){success,_ in
            guard success else {
                return
            }
            print ("All Sets")
        }
    }
    
    func showNotificationWhenLogin(){
        let content = UNMutableNotificationContent()
        content.title = "Welcome back"
        content.subtitle = "Hello User"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        print ("Request sent")
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
