/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

import Foundation
import AVKit
import FirebaseStorage
import UIKit

class UploadControl : ObservableObject {
    @Published var record = false
    // creating instance for recroding...
    
    @Published var session : AVAudioSession!
    @Published var recorder : AVAudioRecorder!
    
    @Published var alert = false
    @Published var isUploaded = false
    
    // MARK: Timer
    @Published var hours: Int8 = 00
    @Published var minutes: Int8 = 00
    @Published var seconds: Int8 = 00
    @Published var timerIsPaused: Bool = true
    @Published var timer: Timer?
    @Published var audio_length : Int = 0
    
    // Fetch Audios...
    var localPath = ""
    private var userViewModel = UserViewModel()
    private var userSettings = UserSettings()
    private var uploadViewModel = UploadViewModel()
    
    // MARK: TIMER FUNCTIONS
    func restartTimer() {
        hours = 0
        minutes = 0
        seconds = 0
    }
    
    // MARK: start timer
    func startTimer() {
        timerIsPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.seconds == 59 {
                self.seconds = 0
                if self.minutes == 59 {
                    self.minutes = 0
                    self.hours += 1
                } else {
                    self.minutes += 1
                }
            } else {
                self.seconds += 1
            }
        }
    }
    
    // MARK: stop timer
    func stopTimer() {
        timerIsPaused = true
        timer?.invalidate()
        timer = nil
        self.audio_length = Int(self.seconds + self.minutes * 60 + self.hours * 60 * 60)
    }
    
    // MARK: record audio
    func recordAudio () {
        // Now going to record audio...
        // Intialization...
        // Were going to store audio in document directory...
        do {
            if self.record {
                // Already Started Recording means stopping and saving...
                
                self.recorder.stop()
                self.record.toggle()
                self.stopTimer()
                return
            }
            
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            // same file name...
            // so were updating based on audio count...
            self.localPath = UUID().uuidString
            let fileName = url.appendingPathComponent("\(localPath).m4a")
            
            let settings = [
                AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey : 12000,
                AVNumberOfChannelsKey : 1,
                AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
            ]
            
            self.recorder = try AVAudioRecorder(url: fileName, settings: settings)
            self.recorder.record()
            
            self.record.toggle()
            self.startTimer()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: request user recording permission
    func requestRecording() {
        do {
            // Intializing...
            self.session = AVAudioSession.sharedInstance()
            try self.session.setCategory(.playAndRecord)
            
            // requesting permission
            // for this we require microphone usage description in info.plist...
            self.session.requestRecordPermission { (status) in
                
                if !status {
                    // error msg...
                    self.alert.toggle()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: upload user casting image
    func uploadCastImage(title: String, description: String, pub_date: String, selectedImage: UIImage?, audio_length: Int) {
        guard selectedImage != nil else {
            return
        }
        let storageRef = Storage.storage().reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "recording_images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        let metadataLocal = StorageMetadata()
        metadataLocal.contentType = "image/jpeg"
        
        _ = fileRef.putData(imageData!, metadata: metadataLocal) { metadata, error in
            if error == nil && metadata != nil {
                fileRef.downloadURL { (url, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    }
                    guard let downloadURL = url else { return }
                    self.uploadCast(title: title, description: description, pub_date: pub_date, image: downloadURL.absoluteString, audio_length: audio_length)
                }
            }
        }
    }
    
    // MARK: upload cast from local folder to firebase storage
    func uploadCast(title: String, description: String, pub_date: String, image: String, audio_length: Int) {
        let storageRef = Storage.storage().reference()
        let globalPath = "recordings/\(localPath)"
        let fileRef = storageRef.child(globalPath)
        do {
            let metadataLocal = StorageMetadata()
            metadataLocal.contentType = "audio/mp3"
            let audioData = try Data(contentsOf: self.recorder.url)
            _ = fileRef.putData(audioData, metadata: metadataLocal) { metadata, error in
                
                if error == nil && metadata != nil {
                    self.isUploaded.toggle()
                    fileRef.downloadURL { (url, error) in
                        if let err = error {
                            print(err.localizedDescription)
                        }
                        guard let downloadURL = url else { return }
                        self.uploadViewModel.upload = Uploads(title: title, description: description, audioPath: downloadURL.absoluteString, author: self.userSettings.username, pub_date: pub_date, image: image, userID: self.userSettings.uuid, numOfLikes: 0, audio_length: audio_length, userImage: self.userSettings.userImage, likes: [], comments: [])
                        self.uploadViewModel.addUploads()
                        self.isUploaded.toggle()
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
