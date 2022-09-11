//
//  SoundControl.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 30/08/2022.
//

import Foundation
import AVKit
import FirebaseStorage
import UIKit

class UploadControl : ObservableObject {
    @Published var record = false
    // creating instance for recroding...
    
    @Published var session : AVAudioSession!
    @Published var recorder : AVAudioRecorder?
    
    @Published var alert = false
    // Fetch Audios...
    var localPath = ""
    private var userViewModel = UserViewModel()
    private var userSettings = UserSettings()
    private var uploadViewModel = UploadViewModel()
    
    func recordAudio () {
        // Now going to record audio...
        // Intialization...
        // Were going to store audio in document directory...
        do {
            if self.record {
                // Already Started Recording means stopping and saving...
                if let recorder = self.recorder {
                    recorder.stop()
                }
                self.record.toggle()
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
            if let recorder = self.recorder {
                recorder.record()
            }
            self.record.toggle()
        } catch {
            print(error.localizedDescription)
        }
    }
    
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
    
    func uploadCastImage(title: String, description: String, pub_date: String, selectedImage: UIImage?) {
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
                    self.uploadCast(title: title, description: description, pub_date: pub_date, image: downloadURL.absoluteString)
                }
            }
        }
    }
    
    func uploadCast(title: String, description: String, pub_date: String, image: String) {
        let storageRef = Storage.storage().reference()
        let globalPath = "recordings/\(localPath)"
        let fileRef = storageRef.child(globalPath)
        do {
            let metadataLocal = StorageMetadata()
            metadataLocal.contentType = "audio/m4a"
            if let recorder = self.recorder {
                let audioData = try Data(contentsOf: recorder.url)
                _ = fileRef.putData(audioData, metadata: metadataLocal) { metadata, error in
                    
                    if error == nil && metadata != nil {
                        print("uploading")
                        
                        fileRef.downloadURL { (url, error) in
                            if let err = error {
                                print(err.localizedDescription)
                            }
                            guard let downloadURL = url else { return }
                            self.uploadViewModel.upload = Uploads(title: title, description: description, audioPath: downloadURL.absoluteString, author: self.userSettings.username, pub_date: pub_date, image: image, userID: self.userSettings.uuid, numOfLikes: 0, likes: [], comments: [])
                            self.uploadViewModel.addUploads()
                        }
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
