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
    @Published var user = Users(token: "", email: "", userName: "", profilePic: "")
    @Published var image: UIImage = UIImage()
    
    private var db = Firestore.firestore()
    
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
                self.addUser(imagePath: path)
            }
        }
    }

    func addUser(imagePath: String) {
        var ref: DocumentReference?
        let token = UUID().uuidString
        ref = db.collection(Settings.usersCollection).addDocument(data: [
            "userName": "Phuong",
            "email": "hello@gmail.com",
            "profilePic": imagePath,
            "token": token
        ]) { error in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.fetchUsers(token: token)
            }
        }
    }
    
    func fetchUsers(token: String) {
        db.collection(Settings.usersCollection).whereField("token", isEqualTo: token).getDocuments(completion: {querySnapShot, error in
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
            self.user = Users(token: token, email: email, userName: userName, profilePic: profilePic)
            
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
}
