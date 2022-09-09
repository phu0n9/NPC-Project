//
//  UploadViewModel.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 07/09/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class UploadViewModel: ObservableObject {
    @Published var uploads = [Uploads]()
    @Published var upload = Uploads(uuid: "", title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", language: "", userID: "", numOfLikes: 0, likes: [], comments: [])
    @Published var lastDocumentSnapshot: DocumentSnapshot!
    @Published var fetchingMore = false
    
    private var db = Firestore.firestore()
    private var userSettings = UserSettings()
    private var likedObj = [Likes]()
    private var commentObj = [Comments]()
    private var userViewModel = UserViewModel()
    
    // MARK: create a upload
    func addUploads() {
        db.collection(Settings.uploadsCollection).document(self.upload.uuid).setData([
            "uuid": self.upload.uuid,
            "title": self.upload.title,
            "audio": self.upload.audioPath,
            "author": self.upload.author,
            "pub_date": self.upload.pub_date,
            "image": self.upload.image,
            "language": self.upload.language,
            "user_id": self.upload.userID,
            "numOfLikes": self.upload.numOfLikes,
            "likedList": [],
            "commentList": [],
            "description": self.upload.description
        ]) {
            error in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.upload.uuid)")
            }
        }
    }
    
    // MARK: initialize firestore object to Swift Object
    func getCommentAndLikeList(likedList: [[String : Any]]?, commentList: [[String : Any]]?) {
        if let likes = likedList {
            self.likedObj = likes.map {(value) -> Likes in
                return Likes(author: value["author"] as! String, userID: value["userID"] as! String)
            }
        }
        
        if let comments = commentList {
            self.commentObj = comments.map {(value) -> Comments in
                return Comments(author: value["author"] as! String, userID: value["userID"] as! String, content: value["content"] as! String)
            }
        }
    }
    
    // MARK: fetch uploads with pagination
    func fetchUploads() {
        fetchingMore = true
        
        var query: Query!
        
        if uploads.isEmpty {
            query = db.collection(Settings.uploadsCollection).order(by: "numOfLikes", descending: true).limit(to: 5)
            print("First 5 uploads loaded")
        } else {
            query = db.collection("rides").order(by: "numOfLikes", descending: true).start(afterDocument: lastDocumentSnapshot).limit(to: 5)
            print("Next 5 uploads loaded")
        }
        
        query.getDocuments { (snapshot, error) in
            if let err = error {
                print("\(err.localizedDescription)")
            }
            
            if snapshot!.isEmpty {
                self.fetchingMore = false
                return
            } else {
                for value in snapshot!.documents {
                    let likedList = value["likedList"] as? [[String: Any]]
                    let commentList = value["commentList"] as? [[String: Any]]
                    
                    self.getCommentAndLikeList(likedList: likedList, commentList: commentList)
                    
                    let newUploads = Uploads(uuid: value.get("uuid") as! String, title: value.get("title") as! String, description: value.get("description") as! String, audioPath: value.get("audio") as! String, author: value.get("author") as! String, pub_date: value.get("pub_date") as! String, image: value.get("image") as! String, language: value.get("language") as! String, userID: value.get("user_id") as! String, numOfLikes: value.get("numOfLikes") as! Int, likes: self.likedObj, comments: self.commentObj)
                    self.uploads.append(newUploads)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.fetchingMore = false
                })
                
                self.lastDocumentSnapshot = snapshot!.documents.last
            }
        }
    }
    
    // MARK: get upload by ID
    func getUploadById(uploadID: String) {
        db.collection(Settings.uploadsCollection).whereField("uuid", isEqualTo: uploadID).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let documents = querySnapShot?.documents else {
                print("No upload data")
                return
            }
            let likedList = documents[0].get("likedList") as? [[String : Any]]
            let commentList = documents[0].get("commentList") as? [[String : Any]]
            
            self.getCommentAndLikeList(likedList: likedList, commentList: commentList)
            
            self.upload = Uploads(uuid: uploadID, title: documents[0].get("title") as! String, description: documents[0].get("description") as! String, audioPath: documents[0].get("audio") as! String, author: documents[0].get("author") as! String, pub_date: documents[0].get("pub_date") as! String, image: documents[0].get("image") as! String, language: documents[0].get("language") as! String, userID: documents[0].get("user_id") as! String, numOfLikes: documents[0].get("numOfLikes") as! Int, likes: self.likedObj, comments: self.commentObj)
        })
    }
    
    // MARK: update uploads
    func updateUploads(uploadID: String, title: String, description: String, selectedImage: UIImage?) {
        db.collection(Settings.usersCollection).whereField("uuid", isEqualTo: uploadID).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let data = querySnapShot?.documents else {
                print("No data")
                return
            }
            
            let storageRef = Storage.storage().reference().child(data[0].get("image") as! String)
            
            storageRef.delete { error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    let imagePath = self.userViewModel.uploadPhoto(selectedImage: selectedImage)
                    
                    data[0].reference.updateData(["title": title, "image": imagePath, "description": description])
                    
                    let likedList = data[0].get("likedList") as? [[String : Any]]
                    let commentList = data[0].get("commentList") as? [[String : Any]]
                    
                    self.getCommentAndLikeList(likedList: likedList, commentList: commentList)
                    self.upload = Uploads(uuid: data[0].get("uuid") as! String, title: title, description: description, audioPath: data[0].get("audio") as! String, author: data[0].get("author") as! String, pub_date: data[0].get("pub_date") as! String, image: imagePath, language: data[0].get("language") as! String, userID: data[0].get("user_id") as! String, numOfLikes: data[0].get("numOfLikes") as! Int, likes: self.likedObj, comments: self.commentObj)
                    self.updateUploadFromUser(uploadID: uploadID, isUpdate: true)
                }
            }
        })
    }
    
    // MARK: update upload from users
    func updateUploadFromUser(uploadID: String, isUpdate: Bool) {
        db.collection(Settings.usersCollection).whereField("uuid", isEqualTo: self.userSettings.uuid).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let data = querySnapShot?.documents else {
                print("No user data")
                return
            }
            
            if var uploadedList = data[0].get("uploadedList") as? [[String : Any]] {
                for (index, item) in uploadedList.enumerated() where item["uuid"] as! String == uploadID {
                    let itemObj: [String : Any] = ["uuid": self.upload.uuid, "title": self.upload.title, "description": self.upload.description, "audio": self.upload.audioPath, "author": self.upload.author, "pub_date": self.upload.pub_date, "image": self.upload.image, "language": self.upload.language, "user_id": self.upload.userID, "numOfLikes": self.upload.numOfLikes, "likedList": item["likedList"] as Any, "commentList": item["commentList"] as Any]
                    uploadedList.remove(at: index)
                    if isUpdate {
                        uploadedList.append(itemObj)
                    }
                }
            }
        })
    }
    
    // MARK: delete upload by ID
    func deleteUplodads(uploadID: String, imagePath: String) {
        db.collection(Settings.uploadsCollection).document(self.userSettings.uuid).delete() { error in
            if let err = error {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                
                let storageRef = Storage.storage().reference().child(imagePath)

                // Delete the image file
                storageRef.delete { errorObj in
                  if let errStr = errorObj {
                      print(errStr.localizedDescription)
                  } else {
                      self.updateUploadFromUser(uploadID: uploadID, isUpdate: false)
                  }
                }
            }
        }
    }
    
    func fetchCommentsByUpload() {
        
    }
    
    func addComments() {
        
    }
    
    func editComments() {
        
    }
    
    func deleteComments() {
        
    }
    
    func updateLikes() {
        
    }
    
}
