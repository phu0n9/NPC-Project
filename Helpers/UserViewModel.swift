//
//  UserViewModel.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 31/08/2022.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import UIKit
import FirebaseAuth

class UserViewModel : ObservableObject {
    @Published var users = [Users]()
    @Published var user = Users(uuid: "", email: "", userName: "", profilePic: "", favoriteTopics: [])
    @Published var image: UIImage = UIImage()
    @Published var userSettings = UserSettings()
    @Published var userFavoriteList = [Episodes]()
    @Published var userWatchedList = [Episodes]()
    @Published var isValid = false
    
    @Published var isUserCurrentlyLoggedOut = false
    private var db = Firestore.firestore()
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
    }
    
    // MARK: uploading photo with selected image
    func uploadPhoto(selectedImage: UIImage?) -> String {
        var fileLocation = ""
        guard selectedImage != nil else {
            return fileLocation
        }
        let storageRef = Storage.storage().reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return fileLocation
        }
        
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        let metadataLocal = StorageMetadata()
        metadataLocal.contentType = "image/jpeg"
        
        _ = fileRef.putData(imageData!, metadata: metadataLocal) { metadata, error in
            
            if error == nil && metadata != nil {
                fileLocation = path
            }
        }
        return fileLocation
    }
    
    // MARK: update user profile picture and categories
    func updateUser(selectedImage: UIImage?, categoryList: [String]) {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).getDocument(completion: { (querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            guard let document = querySnapShot else {
                print("No user found")
                return
            }
            
            // if users don't choose image to update
            guard selectedImage != nil else {
                // update new data
                document.reference.updateData(["categoryList": categoryList])
                self.userSettings.userCategories = categoryList
                return
            }
            
            // upload new photo to firebase storage
            let imagePath = self.uploadPhoto(selectedImage: selectedImage)
            
            // find old photo and delete it
            let image = document.get("image") as! String
            if image != "" {
                let storageRef = Storage.storage().reference().child(image)
                
                // Delete the image file
                storageRef.delete { error in
                    if let err = error {
                        print(err.localizedDescription)
                    } else {
                        print("Deleted old picture")
                    }
                }
            }
            
            // update new data
            document.reference.updateData(["profilePic": imagePath, "categoryList": categoryList])
            self.userSettings.userCategories = categoryList
        })
    }
    
    // MARK: add user
    func addUser() {
        let token = UUID().uuidString
        db.collection(Settings.usersCollection).document(self.user.uuid).setData([
            "uuid": self.user.uuid,
            "userName": self.user.userName,
            "email": self.user.email,
            "profilePic": "",
            "categoryList": self.user.favoriteTopics,
            "token": token
        ]) { error in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
                self.userSettings.token = token
                self.userSettings.username = self.user.userName
                self.userSettings.userCategories = self.user.favoriteTopics
            }
        }
    }
    
    // MARK: user log in
    func userLogin(userID: String) {
        self.userSettings.uuid = userID
        db.collection(Settings.usersCollection).document(userID).getDocument(completion: { (querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            guard let document = querySnapShot else {
                print("No data")
                return
            }
            let token = UUID().uuidString
            document.reference.updateData(["token": token])
            self.userSettings.token = token
            self.userSettings.username = document.get("userName") as! String
            self.userSettings.userCategories = document.get("categoryList") as! [String]
        })
    }
    
    // MARK: fetch users by their uuid
    func fetchUsers(uuid: String) {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).getDocument(completion: {document, error in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            
            let email = document.get("email") as! String
            let userName = document.get("userName") as! String
            let profilePic = document.get("profilePic") as! String
            let uuid = document.get("uuid") as! String
            let favoriteTopics = document.get("categoryList") as! [String]
            
            self.user = Users(uuid: uuid, email: email, userName: userName, profilePic: profilePic, favoriteTopics: favoriteTopics)
            
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child(profilePic)
            
            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if error == nil && data != nil {
                    if let img = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            self.image = img
                        }
                    }
                }
            }
        })
    }
    
    // MARK: check current user token
    func checkUserValidation() {
        guard self.userSettings.uuid != "" else {
            return
        }
        
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).getDocument(completion: { (querySnapShot, error) in
        if let err = error {
                print("Error getting documents: \(err)")
            }
            guard let document = querySnapShot else {
                return
            }
            
            if document.get("token") as! String == self.userSettings.token {
                self.isValid = true
            }
        })
    }
    
    // MARK: add to favorite list
    func addFavorite(favorite: Episodes) {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.favoriteListCollection).getDocuments(completion: {(querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            let favoriteObj = ["audio": favorite.audio, "audio_length": favorite.audio_length, "description": favorite.description, "episode_uuid": favorite.episode_uuid, "podcast_uuid": favorite.podcast_uuid, "pub_date": favorite.pub_date, "title": favorite.title, "image": favorite.image, "user_id": self.userSettings.uuid] as [String : Any]
            
            guard let data = querySnapShot?.documents else {
                print("No data")
                self.db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.favoriteListCollection).document(favorite.episode_uuid).setData(favoriteObj)
                return
            }
            
            guard !data.isEmpty else {
                return
            }
            
            for item in data {
                if item.get("episode_uuid") as! String != favorite.episode_uuid {
                    print("not equal")
                    self.db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.favoriteListCollection).document(favorite.episode_uuid).setData(favoriteObj)
                    return
                } else {
                    print("equal")
                    self.db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.favoriteListCollection).document(favorite.episode_uuid).delete()
                    return
                }
            }
        })
    }
    
    // MARK: fetch favorite list
    func fetchFavoriteList() {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.favoriteListCollection).getDocuments(completion: { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            guard let documents = querySnapshot?.documents else {
                print("No data")
                return
            }
            
            self.userFavoriteList = documents.map {(value) -> Episodes in
                return Episodes(audio: value.get("audio") as! String, audio_length: value.get("audio_length") as! Int, description: value.get("description") as! String, episode_uuid: value.get("episode_uuid") as! String, podcast_uuid: value.get("podcast_uuid") as! String, pub_date: value.get("pub_date") as! String, title: value.get("title") as! String, image: value.get("episode_image") as! String, user_id: value.get("user_id") as! String)
            }
        })
    }
    
    // MARK: add watched episodes
    func addWatchList(watchItem: Episodes) {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.watchListCollection).getDocuments(completion: {(querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            let watchedObj = ["audio": watchItem.audio, "audio_length": watchItem.audio_length, "description": watchItem.description, "episode_uuid": watchItem.episode_uuid, "podcast_uuid": watchItem.podcast_uuid, "pub_date": watchItem.pub_date, "title": watchItem.title, "image": watchItem.image, "user_id": self.userSettings.uuid] as [String : Any]
            
            guard let data = querySnapShot?.documents else {
                print("No data")
                self.db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.watchListCollection).document(watchItem.episode_uuid).setData(watchedObj)
                return
            }
            
            guard !data.isEmpty else {
                return
            }
            
            for item in data where item.get("episode_uuid") as! String != watchItem.episode_uuid {
                print("not equal")
                self.db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.watchListCollection).document(watchItem.episode_uuid).setData(watchedObj)
                return
            }
        })
    }
    
    // MARK: fetch all watched list by userID
    func fetchWatchedList() {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.watchListCollection).getDocuments(completion: { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            guard let documents = querySnapshot?.documents else {
                print("No data")
                return
            }
            
            self.userWatchedList = documents.map {(value) -> Episodes in
                return Episodes(audio: value.get("audio") as! String, audio_length: value.get("audio_length") as! Int, description: value.get("description") as! String, episode_uuid: value.get("episode_uuid") as! String, podcast_uuid: value.get("podcast_uuid") as! String, pub_date: value.get("pub_date") as! String, title: value.get("title") as! String, image: value.get("episode_image") as! String, user_id: value.get("user_id") as! String)
            }
        })
    }
    
    func resetUserDefault() {
        self.userSettings.token = ""
        self.userSettings.username = ""
        self.userSettings.userCategories = ["Art", "Music", "Technology"]
    }
}
