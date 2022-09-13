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
    @ObservedObject var textBindingManager = TextBindingManager(limit: 30)
    @State var isSubmit = false
    @StateObject var uploadControl = UploadControl()
    @ObservedObject var userSettings = UserSettings()
    @State var state = 0
    @State var selectedImage: UIImage?
    @State var isPickerShowing = false
    @State var uploadList = [String]()
    @State var alertMessage = ""
    @State var alertState = false
    @State var isFinishedRecord = false
    @EnvironmentObject var routerView: RouterView

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    switch state {
                    case 0:
                        Text("Cover Image")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        if self.selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .frame(width: 350, height: 250, alignment: .center)
                                .padding(.leading, 20)
                                .onTapGesture {
                                    self.isPickerShowing = true
                                }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 350, height: 250, alignment: .center)
                                .padding(.leading, 20)
                                .onTapGesture {
                                    self.isPickerShowing = true
                                }
                        }
                        Text("Title")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.leading, 20)
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
                        
                        Text("Description")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        
                        Capsule()
                        /* #f5f5f5 */
                            .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                            .frame(width: 380, height: 150, alignment: .center)
                            .padding(0)
                            .overlay(
                                HStack {
                                    TextField("Description", text: self.$textBindingManager.text)
                                        .offset(x: 40, y: 0)
                                }
                            )
                            .padding(6)
                            .autocapitalization(.none)
                        
                    case 1:
                        // MARK: Back button
                        Button {
                            self.state -= 1
                        } label: {
                            Image(systemName: "arrowshape.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .background(Color("MainButton"))
                        }
                        .padding(.leading, 20)
                        
                        Text("Recording your cast")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        
                        VStack(alignment: .center) {
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
                            .disabled(self.isFinishedRecord)
                            .onAppear {
                                self.uploadControl.requestRecording()
                            }
                            .onChange(of: self.uploadControl.record) { value in
                                if !value {
                                    if self.uploadControl.recorder?.url != nil {
                                        self.isFinishedRecord = true
                                    }
                                }
                            }
                            
                            if self.isFinishedRecord {
                                withAnimation(.spring()) {
                                    RecordingPlayerBtn(soundName: self.uploadControl.recorder?.url.relativeString ?? "", isDeleted: self.$isFinishedRecord)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        
                    default:
                        EmptyView()
                    }
                    Button {
                        self.handleUpload(value: self.state)
                    } label: {
                        HStack {
                            Spacer()
                            Text(state != 1 ? "Next": "Cast away")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color("MainButton"))
                    }
                    .padding(.leading, 20)
                    .frame(width: 380, height: 50)
                }
            }
            .navigationBarHidden(true)
            .frame(alignment: .leading)
            .padding()
        }
        .alert(isPresented: self.$uploadControl.alert, content: {
            Alert(title: Text("Error"), message: Text("Please enable microphone access"))
        })
        .alert(isPresented: self.$alertState, content: {
            Alert(title: Text("Error"), message: Text(self.alertMessage))
        })
        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
    }
    
    func handleUpload(value: Int) {
        switch value {
        case 0:
            if title == "" {
                self.alertMessage = "Please insert title!"
                self.alertState = true
            } else if selectedImage == nil {
                self.alertMessage = "Please upload image!"
                self.alertState = true
            } else {
                self.state += 1
            }
        case 1:
            if self.uploadControl.recorder == nil {
                self.alertMessage = "Please upload record!"
                self.alertState.toggle()
            } else {
                let mytime = Date()
                let format = DateFormatter()
                format.timeStyle = .short
                format.dateStyle = .short
                let time = format.string(from: mytime)
                self.uploadControl.uploadCastImage(title: title, description: self.textBindingManager.text, pub_date: time, selectedImage: selectedImage)
                withAnimation {
                    routerView.currentPage = .castingUser
                }
                self.state = 0
            }
        default:
            self.state = 0
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
