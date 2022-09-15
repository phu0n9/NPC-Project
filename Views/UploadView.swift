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
    @State var selectedImage: UIImage?
    @State var isPickerShowing = false
    @State var uploadList = [String]()
    @State var alertMessage = ""
    @State var alertState = false
    @State var isFinishedRecord = false
    @EnvironmentObject var routerView: RouterView
    
    //MARK: Timer
    @State var hours: Int8 = 00
    @State var minutes: Int8 = 00
    @State var seconds: Int8 = 00
    @State var timerIsPaused: Bool = true
    @State var timer: Timer? = nil
    
    
    var body: some View {
        
        
        
        NavigationView {
            
            ScrollView {
                
                VStack(spacing:0) {
                    
                    VStack(alignment: .center) {
    
                        Text("Record your podcast")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .frame(width: 350, height: 50, alignment: .leading)

                        Capsule()
                        /* #f5f5f5 */
                            .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                            .frame(width: UIScreen.main.bounds.width-30, height: 40)
                        
                            .overlay(
                                HStack {
                                    TextField("Enter your Podcasts' Title", text: $title)
                                        .offset(x: 30, y: 0)
                                }
                            )
                            .padding(6)
                            .autocapitalization(.none)
                        
                        Capsule()
                        /* #f5f5f5 */
                            .foregroundColor(Color(red: 0.9608, green: 0.9608, blue: 0.9608))
                            .frame(width: UIScreen.main.bounds.width-30, height: 40, alignment: .center)
                            .padding(0)
                            .overlay(
                                HStack {
                                    TextField("Describe your Podcast in one sentence", text: self.$textBindingManager.text)
                                        .offset(x: 30, y: 0)
                                }
                            )
                            .padding(10)
                            .autocapitalization(.none)
                        
                        Text("Cover Image")
                            .font(.system(size: 15))
                            .padding(10)
                            .frame(width: 200, height: 50, alignment: .center)
                        
                        if self.selectedImage != nil {
                            
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Rectangle())
                                .cornerRadius(20)
                                .onTapGesture {
                                    self.isPickerShowing = true
                                }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100, alignment: .center)
                                .clipShape(Rectangle())
                                .cornerRadius(20)
                                .onTapGesture {
                                    self.isPickerShowing = true
                                }
                        }

                        if self.isFinishedRecord == false {
                            
                            VStack(alignment: .center) {
                                
                                //MARK: TIMER
                                VStack {
                                    
                                      Text("\(hours) : \(minutes) : \(seconds) ")
                                    //Text(String(format: "%.2f", hours))
                                        .font(.system(size: 36))
                                        .bold()
                                    
                                    if timerIsPaused {
                                        HStack {
                                          Button(action:{
                                              self.restartTimer()
                                          }){
                                            Image(systemName: "backward.end.alt")
                                              
                                          }
                                        
                                            
                                            
                                          Button(action:{
                                              
                                            self.startTimer()
                                              self.uploadControl.recordAudio()
                                          }){
//                                            Image(systemName: "play.fill")
                                              Button(action: {
                                                  self.uploadControl.recordAudio()
                                              }, label: {
                                                  ZStack {
                                                      
                                                      Circle()
                                                          .frame(width:50, height: 100)
                                                          .foregroundColor(Color("MainButton"))
                                                          .border(Color("MainButton"))
                                                      
                                                      if self.uploadControl.record {
                                                          Circle()
                                                              .stroke(Color("MainButton"))
                                                              .frame(width:50, height: 50)
                                                              .foregroundColor(Color("MainButton"))
                                                      }
                                                      
                                                      Image(systemName: self.uploadControl.record ?  "pause.fill" : "play.fill")
                                                          .resizable()
                                                          .aspectRatio(contentMode: .fit)
                                                          .frame(width: 10, height: 10, alignment:.trailing)
                                                          .foregroundColor(.white)
                                                      
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
                                          }
                                          
                                        }
                                      } else {
                                        Button(action:{
                                         
                                          self.stopTimer()
                                            
                                        }){
                                          Image(systemName: "stop.fill")
                                           
                                        }
                                        
                                      }
                                    }
                                    
                                
                                

                                
                                
                                
                                
                                Spacer()
                                
                            }
                            .frame(width: UIScreen.main.bounds.width)
                        } else {
                            withAnimation(.spring()) {
                                RecordingPlayerBtn(soundName: self.uploadControl.recorder?.url.relativeString ?? "", isDeleted: self.$isFinishedRecord)
                            }
                            
                            Spacer()
                            
                            Button {
                                self.handleUpload()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text( "Cast away")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 18, weight: .bold))
                                    Spacer()
                                }.background(Color("MainButton"))
                            }
                            .padding(.top, 100)
                            .frame(width: 200, height: 50)
                            
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
        }
    }
    
    // MARK: HandleUpload fuction
    func handleUpload() {
        if title == "" {
            self.alertMessage = "Please insert title!"
            self.alertState = true
        } else if selectedImage == nil {
            self.alertMessage = "Please upload image!"
            self.alertState = true
        } else if self.uploadControl.recorder == nil {
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
                routerView.currentPage = .bottomNavBar
            }
        }
    }
    
    
    func restartTimer(){
      hours = 0
      minutes = 0
      seconds = 0
    }
    
        func startTimer(){
          timerIsPaused = false
          timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            if self.seconds == 59 {
              self.seconds = 0
              if self.minutes == 59 {
                self.minutes = 0
                self.hours = self.hours + 1
              } else {
                self.minutes = self.minutes + 1
              }
            } else {
              self.seconds = self.seconds + 1
            }
          }
        }
    
        func stopTimer(){
          timerIsPaused = true
          timer?.invalidate()
          timer = nil
        }
}


 

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
