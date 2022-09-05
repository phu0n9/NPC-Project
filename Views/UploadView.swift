//
//  UploadView.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 02/09/2022.
//

import SwiftUI
import AVKit

struct UploadView : View {
    
    @State var title = ""
    @State var description = ""
    @State var isSubmit = false
    @Environment(\.colorScheme) var colorScheme
    @StateObject var uploadControl = UploadControl()
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    Group {
                        TextField("Title", text: $title)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        TextField("Description", text: $description)
                    }
                    .padding(12)
                    .background(Color.white)
                    
                    //                    List(self.soundControl.audios, id: \.self) { value in
                    //                        // printing only file name...
                    //                        Text(value.relativeString)
                    //                    }
                    
                    Button(action: {self.uploadControl.recordAudio()}, label: {
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 70, height: 70)
                            
                            if self.uploadControl.record {
                                Circle()
                                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 6)
                                    .frame(width: 85, height: 85)
                            }
                        }
                    })
                    .padding(.vertical, 25)
                    Button("Cast away") {
                        self.uploadControl.uploadCast(title: title, description: description, pub_date: "2022/09/02", image: "", language: "english")
                    }
                }
                .navigationBarTitle("Upload cast")
            }
        }
        .alert(isPresented: self.$uploadControl.alert, content: {
            Alert(title: Text("Error"), message: Text("Enable Acess"))
        })
        .onAppear {
            self.uploadControl.requestRecording()
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
