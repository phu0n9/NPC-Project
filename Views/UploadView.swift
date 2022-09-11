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
    @StateObject var uploadControl = UploadControl()
    @ObservedObject var userSettings = UserSettings()
    @State private var state = 0
    @State var selectedImage: UIImage?
    @State var isPickerShowing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    switch state {
                    case 0:
                        Text("Cover Image")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        if self.selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150, alignment: .center)
                                .padding()
                                .onTapGesture {
                                    self.isPickerShowing = true
                                }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200, alignment: .center)
                                .padding()
                                .onTapGesture {
                                    self.isPickerShowing = true
                                }
                        }
                        Text("Title")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Capsule()
                        /* #f5f5f5 */
                            .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                            .frame(width: 380, height: 50)
                            .padding(0)
                            .overlay(
                                HStack {
                                    TextField("Title", text: $title)
                                        .offset(x: 40, y: 0)
                                }
                            )
                            .padding(6)
                            .autocapitalization(.none)
                        
                    case 1:
                        Text("Recording your cast")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Button(action: {
                            self.uploadControl.recordAudio()
                            
                        }, label: {
                            ZStack {
                                Circle()
                                    .frame(width: 150, height: 150)
                                    .foregroundColor(Color("MainButton"))
                                if self.uploadControl.record {
                                    Circle()
                                        .stroke(Color.black)
                                        .frame(width: 160, height: 160)
                                }
                                Image(systemName: "play")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .foregroundColor(Color.black)
                                    .padding()
                            }
                        })
                        .padding(.vertical, 25)
                        .onAppear {
                            self.uploadControl.requestRecording()
                        }
                        
//                        Section {
//                            Picker("Pick your best upload", selection: self.$uploadControl.selectedUpload) {
//                                ForEach(self.uploadControl.audio, id: \.self) { record in
//                                    Text(record.relativeString)
//                                }
//                            }
//                        }
                        List(self.uploadControl.audio, id: \.self) {value in
                            
                            Text(value.relativeString)
                        }
                        
                    case 2:
                        Text("Description")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        TextField("Description", text: $description)
                            .frame(width: UIScreen.main.bounds.width - 50, height: 100, alignment: .leading)
                        
                    default:
                        EmptyView()
                    }
                    Button {
                        self.state += 1
                    } label: {
                        HStack {
                            Spacer()
                            Text(state != 2 ? "Next": "Cast away")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color("MainButton"))
                    }
                    .padding(0)
                    .frame(width: 380, height: 50)
                    .onChange(of: state) { value in
                        if value == 3 {
                            let mytime = Date()
                            let format = DateFormatter()
                            format.timeStyle = .short
                            format.dateStyle = .short
                            let time = format.string(from: mytime)
                            self.uploadControl.uploadCastImage(title: title, description: description, pub_date: time, selectedImage: selectedImage)
                            print("Uploading")
                            self.state = 0
                        }
                    }
                    if state != 0 {
                        Button {
                            self.state -= 1
                        } label: {
                            HStack {
                                Spacer()
                                Text("Back")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                            }.background(Color("MainButton"))
                        }
                        .padding(0)
                        .frame(width: 380, height: 50)
                    }
                }
            }
            .navigationBarHidden(true)
            .frame(alignment: .leading)
        }
        .alert(isPresented: self.$uploadControl.alert, content: {
            Alert(title: Text("Error"), message: Text("Please enable microphone access"))
        })
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
