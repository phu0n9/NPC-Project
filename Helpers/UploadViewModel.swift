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
    
    // MARK: create uploads
    func addUploads() {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).getDocument(completion: { (querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            let uploadObj = ["uuid": self.upload.uuid, "title": self.upload.title, "description": self.upload.description, "audioPath": self.upload.audioPath, "author": self.upload.author, "pub_date": self.upload.pub_date, "image": self.upload.image, "language": self.upload.language, "userID": self.upload.userID, "numOfLikes": self.upload.numOfLikes, "likes": [], "comments": []] as [String : Any]
        
            self.db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.uploadsCollection).addDocument(data: uploadObj)
        })
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
            query = db.collectionGroup(Settings.uploadsCollection).order(by: "numOfLikes", descending: true).limit(to: 5)
            print("First 5 uploads loaded")
        } else {
            query = db.collectionGroup(Settings.uploadsCollection).order(by: "numOfLikes", descending: true).start(afterDocument: lastDocumentSnapshot).limit(to: 5)
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
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.uploadsCollection).document(uploadID).getDocument(completion: { (querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let document = querySnapShot else {
                print("No upload data")
                return
            }
            let likedList = document.get("likedList") as? [[String : Any]]
            let commentList = document.get("commentList") as? [[String : Any]]
            
            self.getCommentAndLikeList(likedList: likedList, commentList: commentList)
            
            self.upload = Uploads(uuid: uploadID, title: document.get("title") as! String, description: document.get("description") as! String, audioPath: document.get("audio") as! String, author: document.get("author") as! String, pub_date: document.get("pub_date") as! String, image: document.get("image") as! String, language: document.get("language") as! String, userID: document.get("user_id") as! String, numOfLikes: document.get("numOfLikes") as! Int, likes: self.likedObj, comments: self.commentObj)
        })
    }
    
    // MARK: update uploads
    func updateUploads(uploadID: String, title: String, description: String, selectedImage: UIImage?) {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.uploadsCollection).document(uploadID).getDocument(completion: { (querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let data = querySnapShot else {
                print("No data")
                return
            }
            
            let storageRef = Storage.storage().reference().child(data.get("image") as! String)
            
            storageRef.delete { error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
//                    data.reference.updateData(["title": title, "image": imagePath, "description": description])
                }
            }
        })
    }
    
    // MARK: delete upload by ID
    func deleteUplodads(uploadID: String, imagePath: String) {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.uploadsCollection).document(uploadID).delete()
        { error in
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
                      print("Upload deleted")
                  }
                }
            }
        }
    }
    
    // MARK: fetch uploads by user id
    func fetchUploadsByUserId() {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.uploadsCollection).order(by: "numOfLikes", descending: true).getDocuments(completion: {(querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let documents = querySnapShot?.documents else {
                print("No upload from userID: \(self.userSettings.uuid)")
                return
            }
            
            self.uploads = documents.map {(value) -> Uploads in
                let likedList = value.get("likedList") as? [[String : Any]]
                let commentList = value.get("commentList") as? [[String : Any]]
                
                self.getCommentAndLikeList(likedList: likedList, commentList: commentList)
                return Uploads(uuid: value.get("uuid") as! String, title: value.get("title") as! String, description: value.get("description") as! String, audioPath: value.get("audio") as! String, author: value.get("author") as! String, pub_date: value.get("pub_date") as! String, image: value.get("image") as! String, language: value.get("language") as! String, userID: value.get("user_id") as! String, numOfLikes: value.get("numOfLikes") as! Int, likes: self.likedObj, comments: self.commentObj)
            }
        })
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
