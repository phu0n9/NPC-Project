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

class UserViewModel : ObservableObject {
    @Published var users = [Users]()
    @Published var user = Users(uuid: "", email: "", userName: "", profilePic: "", favoriteTopics: [])
    @Published var image: UIImage = UIImage()
    @Published var userSettings = UserSettings()
    @Published var isValid = false
    
    private var db = Firestore.firestore()
    
    // MARK: uploading photo with selected image
    func uploadPhoto(selectedImage: UIImage?) {
        guard selectedImage != nil else {
            return
        }
        let storageRef = Storage.storage().reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            if error == nil && metadata != nil {
                self.updateProfilePicture(imagePath: path)
            }
        }
    }

    // MARK: update user profile picture
    func updateProfilePicture(imagePath: String) {
        db.collection(Settings.usersCollection).whereField("uuid", isEqualTo: self.userSettings.uuid).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            guard let documents = querySnapShot?.documents else {
                print("No data")
                return
            }
            documents[0].reference.updateData(["profilePic": imagePath])
        })
    }
    
    // MARK: add user
    func addUser() {
        var ref: DocumentReference?
        let token = UUID().uuidString
        ref = db.collection(Settings.usersCollection).addDocument(data: [
            "uuid": self.user.uuid,
            "userName": self.user.userName,
            "email": self.user.email,
            "profilePic": "",
            "token": token
        ]) { error in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.userSettings.token = token
            }
        }
    }
    
    // MARK: user log in
    func userLogin() {
        db.collection(Settings.usersCollection).whereField("uuid", isEqualTo: self.userSettings.uuid).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            guard let documents = querySnapShot?.documents else {
                print("No data")
                return
            }
            let token = UUID().uuidString
            documents[0].reference.updateData(["token": token])
            self.userSettings.token = token
        })
    }
    
    // MARK: fetch users by their uuid
    func fetchUsers(uuid: String) {
        db.collection(Settings.usersCollection).whereField("uuid", isEqualTo: uuid).getDocuments(completion: {querySnapShot, error in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            guard let documents = querySnapShot?.documents else {
                print("No data")
                return
            }
            
            let email = documents[0].get("email") as! String
            let userName = documents[0].get("userName") as! String
            let profilePic = documents[0].get("profilePic") as! String
            let uuid = documents[0].get("uuid") as! String
            let favoriteTopics = documents[0].get("favoriteTopics") as! [String]
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
        db.collection(Settings.usersCollection).whereField("token", isEqualTo: self.userSettings.token).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            guard let documents = querySnapShot?.documents else {
                print("No data")
                self.isValid = false
                return
            }
            
            self.isValid = true
        })
    }
}
