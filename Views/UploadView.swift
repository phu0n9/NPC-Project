import SwiftUI
import AVKit
struct UploadView : View {
    
    @State var title = ""
    @ObservedObject var textBindingManager = TextBindingManager(limit: 100)
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
 
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(alignment: .center, spacing: 10) {
                    
                    switch state {
                    case 0:
                        Text("Record your podcast")
                            .font(.title2)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .frame(width: 350, height: 50, alignment: .leading)
                        if self.selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Rectangle())
                                .cornerRadius(20)
                                .onTapGesture {
                                    self.isPickerShowing = true
                                    Image(systemName: "plus.circle.fill")
                                        .renderingMode(.template)
                                        .font(.system(size:25,
                                                      weight: .regular,
                                                      design: .default))
                                        .foregroundColor(Color("MainButton"))
                                        .offset(x: 46, y: -26)
                                }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100, alignment: .center)
                                .clipShape(Rectangle())
                                .cornerRadius(20)
                            Image(systemName: "plus.circle.fill")
                                .renderingMode(.template)
                                .font(.system(size:25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(Color("MainButton"))
                                .offset(x: 46, y: -26)
                            
                                .onTapGesture {
                                    self.isPickerShowing = true
                                }
                        }
                        
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
                        
                    case 1:
                        
                        // MARK: Back button
                        Button {
                            
                            self.state -= 1
                            
                        } label: {
                            
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color(.black))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350, height: 15, alignment: .leading)
                                .font(.system(size:10,
                                              weight: .regular,
                                              design: .default))
                        }
                        
                        Text("Recording your cast")
                            .font(.title2)
                            .padding(.leading, 20)
                            .frame(width: 350, height: 30, alignment: .leading)
                        
                        Text(String(format: "%02d : %02d : %02d", self.uploadControl.hours, self.uploadControl.minutes, self.uploadControl.seconds))
                            .font(.system(size: 36))
                            .bold()
                        
                        Spacer()

                        HStack {
                            // MARK: Recording, timer btn
                            Button(action: {
                                self.uploadControl.recordAudio()
                            }, label: {
                                ZStack {
                                    Circle()
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(Color("MainButton"))
                                    
                                    Image(systemName: self.uploadControl.timerIsPaused ? "play.fill" : "pause.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .foregroundColor(Color.black)
                                        .padding()
                                }
                            })
                            
                            .disabled(self.isFinishedRecord)
                            .onAppear {
                                self.uploadControl.requestRecording()
                            }
                            
                            .onChange(of: self.uploadControl.record) { value in
                                print(value)
                                if !value {
                                    if self.uploadControl.recorder?.url != nil {
                                        self.isFinishedRecord = true
                                        
                                    }
                                }
                            }
                            
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        
                        if self.isFinishedRecord {
                            withAnimation(.spring()) {
                                RecordingPlayerBtn(soundName: self.uploadControl.recorder?.url.relativeString ?? "", isDeleted: self.$isFinishedRecord)
                            }
                        }

                    default:
                        EmptyView()
                    }
                    
                    Spacer()
                    
                    Button {
                        self.handleUpload(value: self.state)
                    } label: {
                        
                        HStack {
                            
                            Spacer()
                            
                            Text(state != 1 ? "Next": "Cast away")
                                .foregroundColor(.white)
                                .padding(10)
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                        }.background(Color("MainButton"))
                    }
                    .padding(20)
                    .frame(width: 240, height: 50)
                    .cornerRadius(20)
                    
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
        .onChange(of: self.isFinishedRecord) { value in
            if !value {
                self.uploadControl.restartTimer()
            }
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
                self.uploadControl.uploadCastImage(title: title, description: self.textBindingManager.text, pub_date: time, selectedImage: selectedImage, audio_length: self.uploadControl.audio_length)
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
