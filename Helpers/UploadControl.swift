//
//  SoundControl.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 30/08/2022.
//

import Foundation
import AVKit
import FirebaseStorage

class UploadControl : ObservableObject {
    @Published var record = false
    // creating instance for recroding...
    
    @Published var session : AVAudioSession!
    @Published var recorder : AVAudioRecorder!
    
    @Published var alert = false
    // Fetch Audios...
    @Published var audio = URL(string: "")
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
                
                self.recorder.stop()
                self.record.toggle()
                // updating data for every rcd...
                self.getAudios()
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
                } else {
                    
                    // if permission granted means fetching all data...
                    
                    self.getAudios()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAudios() {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            // fetch all data from document directory...
            var result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            // updated means remove all old data..
            result.removeAll()
            if !result.isEmpty {
                self.audio = result[0]
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func uploadCast(title: String, description: String, pub_date: String, image: String, language: String) {
        let storageRef = Storage.storage().reference()
        let globalPath = "recordings/\(localPath)"
        let fileRef = storageRef.child(globalPath)
        do {
            let metadataLocal = StorageMetadata()
            metadataLocal.contentType = "audio/m4a"
            let audioData = try Data(contentsOf: self.recorder.url)
            _ = fileRef.putData(audioData, metadata: metadataLocal) { metadata, error in
                
                if error == nil && metadata != nil {
                    print("uploading")
                    
//                    fileRef.downloadURL { (url, error) in
//                        if let err = error {
//                            print(err.localizedDescription)
//                        }
//                        guard let downloadURL = url else { return }
//                        debugPrint("download link", downloadURL)
//                        debugPrint("path", downloadURL.path)
//
//
//                    }
                    let upload = Uploads(uuid: UUID().uuidString, title: title, description: description, audioPath: globalPath, author: self.userSettings.username, pub_date: pub_date, image: image, language: language, userID: self.userSettings.uuid, numOfLikes: 0, likes: [], comments: [])
                    self.uploadViewModel.upload = upload
                    self.uploadViewModel.addUploads()
                    self.userViewModel.addUploadCast(upload: upload)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
