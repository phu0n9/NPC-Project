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
    @Published var user = Users(uuid: "", email: "", userName: "", profilePic: "", favoriteTopics: [], uploadedList: [], watchedList: [], favoriteList: [])
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
    
    // MARK: User upload cast
    func addUploadCast(upload: Uploads) {
        db.collection(Settings.usersCollection).whereField("uuid", isEqualTo: self.userSettings.uuid).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            guard let documents = querySnapShot?.documents else {
                print("No data")
                return
            }
            let uploadedList = documents[0].get("uploadedList") as? [[String : Any]]
            if var uploads = uploadedList {
                let uploadObj = ["uuid": upload.uuid, "title": upload.title, "description": upload.description, "audioPath": upload.audioPath, "author": upload.author, "pub_date": upload.pub_date, "image": upload.image, "language": upload.language]
                if uploads.isEmpty {
                    documents[0].reference.updateData(["uploadedList": [uploadObj]])
                } else {
                    uploads.append(uploadObj)
                    documents[0].reference.updateData(["uploadedList": uploads])
                }
            }
            
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
            "categoryList": self.user.favoriteTopics,
            "uploadedList" : self.user.uploadedList,
            "favoriteList": self.user.favoriteList,
            "watchedList": self.user.watchedList,
            "token": token
        ]) { error in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.userSettings.token = token
                self.userSettings.username = self.user.userName
                self.userSettings.userCategories = self.user.favoriteTopics
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
            self.userSettings.username = documents[0].get("userName") as! String
            self.userSettings.userCategories = documents[0].get("categoryList") as! [String]
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
            let favoriteTopics = documents[0].get("categoryList") as! [String]
            let uploadedList = documents[0].get("uploadedList") as? [[String: Any]]
            let watchedList = documents[0].get("watchedList") as? [[String: Any]]
            let favoriteList = documents[0].get("favoriteList") as? [[String: Any]]
            var uploadObj = [Uploads]()
            var watchedObj = [Episodes]()
            var favoriteListObj = [Episodes]()
            
            if let uploads = uploadedList {
                uploadObj = uploads.map {(value) -> Uploads in
                    let likedList = value["likedList"] as? [[String: Any]]
                    let commentList = value["commentList"] as? [[String: Any]]
                    var likedObj = [Likes]()
                    var commentObj = [Comments]()
                    
                    if let likes = likedList {
                        likedObj = likes.map {(value) -> Likes in
                            return Likes(author: value["author"] as! String, userID: value["userID"] as! String)
                        }
                    }
                    
                    if let comments = commentList {
                        commentObj = comments.map {(value) -> Comments in
                            return Comments(author: value["author"] as! String, userID: value["userID"] as! String, content: value["content"] as! String)
                        }
                    }
                    
                    return Uploads(uuid: value["uuid"] as! String, title: value["title"] as! String, description: value["description"] as! String, audioPath: value["audio"] as! String, author: value["author"] as! String, pub_date: value["pub_date"] as! String, image: value["image"] as! String, language: value["language"] as! String, userID: uuid, numOfLikes: value["numOfLikes"] as! Int, likes: likedObj, comments: commentObj)
                }
            }
            
            if let watchedItems = watchedList {
                watchedObj = watchedItems.map {(value) -> Episodes in
                    return Episodes(audio: value["audio"] as! String, audio_length: value["audio_lentgh"] as! Int, description: value["description"] as! String, episode_uuid: value["episode_uuid"] as! String, podcast_uuid: value["podcast_uuid"] as! String, pub_date: value["pub_date"] as! String, title: value["title"] as! String, image: "")
                }
            }
            
            if let favoriteItems = favoriteList {
                favoriteListObj = favoriteItems.map {(value) -> Episodes in
                    return Episodes(audio: value["audio"] as! String, audio_length: value["audio_length"] as! Int, description: value["description"] as! String, episode_uuid: value["episode_uuid"] as! String, podcast_uuid: value["podcast_uuid"] as! String, pub_date: value["pub_date"] as! String, title: value["title"] as! String, image: "")
                }
            }
            
            self.user = Users(uuid: uuid, email: email, userName: userName, profilePic: profilePic, favoriteTopics: favoriteTopics, uploadedList: uploadObj, watchedList: watchedObj, favoriteList: favoriteListObj)
            
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
    
    // MARK: initialize list of podcasts
    func getList(podcasts: [[String : Any]]) -> [Podcasts] {
        return podcasts.map {(queryDocumentSnapshot) -> Podcasts in
            let author = queryDocumentSnapshot["author"] as! String
            let categories = queryDocumentSnapshot["categories"] as! [String]
            let description = queryDocumentSnapshot["description"] as! String
            let image = queryDocumentSnapshot["image"] as! String
            let itunes_id = queryDocumentSnapshot["itunes_id"] as! Int32
            let language = queryDocumentSnapshot["language"] as! String
            let title = queryDocumentSnapshot["title"] as! String
            let uuid = queryDocumentSnapshot["uuid"] as! String
            let website = queryDocumentSnapshot["website"] as! String
            let episodeList = queryDocumentSnapshot["episodes"] as? [[String: Any]]
            
            var episodeObj = [Episodes]()
            if let episodes = episodeList {
                episodeObj = episodes.map {(value) -> Episodes in
                    return Episodes(audio: value["audio"] as! String, audio_length: value["audio_length"] as! Int, description: value["description"] as! String, episode_uuid: value["episode_uuid"] as! String, podcast_uuid: value["podcast_uuid"] as! String, pub_date: value["pub_date"] as! String, title: value["title"] as! String, image: image)
                }
            }
            
            return Podcasts(uuid: uuid, author: author, description: description, image: image, itunes_id: itunes_id, language: language, title: title, website: website, categories: categories, episodes: episodeObj)
        }
    }
    
    // MARK: check current user token
    func checkUserValidation() {
        db.collection(Settings.usersCollection).whereField("token", isEqualTo: self.userSettings.token).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            guard (querySnapShot?.documents) != nil else {
                print("No data")
                self.isValid = false
                return
            }
            
            self.isValid = true
        })
    }
}
