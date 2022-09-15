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
    @Published var upload = Uploads(uuid: "", title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", userID: "", numOfLikes: 0, audio_length: 0, userImage: "", likes: [], comments: [])
    @Published var lastDocumentSnapshot: DocumentSnapshot!
    @Published var fetchingMore = false
    
    @Published var comment = Comments(uuid: "", author: "", userID: "", content: "", image: "")
    @Published var like = Likes(author: "", userID: "", isLiked: false)
    @Published var likedList = [Likes]()
    @Published var commentList = [Comments]()
    
    private var db = Firestore.firestore()
    private var userSettings = UserSettings()
    private var userViewModel = UserViewModel()
    
    // MARK: create uploads
    func addUploads() {
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).getDocument(completion: { (_, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            
            let uploadObj = ["uuid": self.upload.uuid, "title": self.upload.title, "description": self.upload.description, "audioPath": self.upload.audioPath, "author": self.upload.author, "pub_date": self.upload.pub_date, "image": self.upload.image, "userID": self.upload.userID, "numOfLikes": self.upload.numOfLikes, "audio_length": self.upload.audio_length, "userImage": self.userSettings.userImage, "commentList": [], "likedList": []] as [String : Any]
            
            self.db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.uploadsCollection).document(self.upload.uuid).setData(uploadObj)
        })
    }
    
    // MARK: fetch comments by uploadID
    func fetchCommentsByUploadID(uploadID: String) {
        db.collectionGroup(Settings.uploadsCollection).whereField("uuid", isEqualTo: uploadID).addSnapshotListener {(querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let uploadObj = querySnapShot?.documents else {
                print("No upload")
                return
            }
            
            let commentObj = uploadObj[0].get("commentList") as? [[String:Any]]
            guard let commentObjList = commentObj else {
                self.commentList = []
                print("No comment")
                return
            }
            
            self.commentList = commentObjList.map {(value) -> Comments in
                return Comments(uuid: value["uuid"] as! String, author: value["author"] as! String, userID: value["userID"] as! String, content: value["content"] as! String, image: value["image"] as! String)
            }
            
        }
    }
    
    // MARK: fetch likes by uploadID
    func fetchLikesByUploadID(uploadID: String) {
        db.collectionGroup(Settings.uploadsCollection).whereField("uuid", isEqualTo: uploadID).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let uploadObj = querySnapShot?.documents else {
                print("No upload")
                return
            }
            
            let likeObj = uploadObj[0].get("likedList") as? [[String:Any]]
            guard let likeObjList = likeObj else {
                self.likedList = []
                print("No likes")
                return
            }
            
            self.likedList = likeObjList.map {(value) -> Likes in
                return Likes(author: value["author"] as! String, userID: value["userID"] as! String, isLiked: value["isLiked"] as! Bool)
            }
        })
    }
    
    // MARK: fetch uploads with pagination
    func fetchUploads() {
        fetchingMore = true
        
        var query: Query!
        
        if uploads.isEmpty {
            query = db.collectionGroup(Settings.uploadsCollection).order(by: "numOfLikes", descending: true).limit(to: 2)
            print("First 5 uploads loaded")
        } else {
            query = db.collectionGroup(Settings.uploadsCollection).order(by: "numOfLikes", descending: true).start(afterDocument: lastDocumentSnapshot).limit(to: 2)
            print("Next 5 uploads loaded")
        }
        
        query.getDocuments { (snapshot, error) in
            if let err = error {
                print("\(err.localizedDescription)")
            }
            
            guard let documents = snapshot?.documents else {
                print("No upload data")
                return
            }
            
            if documents.isEmpty {
                self.fetchingMore = false
                return
            } else {
                for value in snapshot!.documents {
                    let uploadID = value.get("uuid") as! String
                    DispatchQueue.main.async {
                        self.fetchCommentsByUploadID(uploadID: uploadID)
                        self.fetchLikesByUploadID(uploadID: uploadID)
                    }
                    
                    let newUploads = Uploads(uuid: uploadID, title: value.get("title") as! String, description: value.get("description") as! String, audioPath: value.get("audioPath") as! String, author: value.get("author") as! String, pub_date: value.get("pub_date") as! String, image: value.get("image") as! String, userID: value.get("userID") as! String, numOfLikes: value.get("numOfLikes") as! Int, audio_length: value.get("audio_length") as! Int, userImage: value.get("userImage") as! String, likes: self.likedList, comments: self.commentList)
                    self.upload = newUploads
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
            self.fetchCommentsByUploadID(uploadID: uploadID)
            self.fetchLikesByUploadID(uploadID: uploadID)
            
            self.upload = Uploads(uuid: uploadID, title: document.get("title") as! String, description: document.get("description") as! String, audioPath: document.get("audio") as! String, author: document.get("author") as! String, pub_date: document.get("pub_date") as! String, image: document.get("image") as! String, userID: document.get("user_id") as! String, numOfLikes: document.get("numOfLikes") as! Int, audio_length: document.get("audio_length") as! Int, userImage: document.get("userImage") as! String, likes: self.likedList, comments: self.commentList)
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
        db.collection(Settings.usersCollection).document(self.userSettings.uuid).collection(Settings.uploadsCollection).document(uploadID).delete { error in
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
                let uploadID = value.get("uuid") as! String
                self.fetchCommentsByUploadID(uploadID: uploadID)
                self.fetchLikesByUploadID(uploadID: uploadID)
                
                return Uploads(uuid: uploadID, title: value.get("title") as! String, description: value.get("description") as! String, audioPath: value.get("audio") as! String, author: value.get("author") as! String, pub_date: value.get("pub_date") as! String, image: value.get("image") as! String, userID: value.get("user_id") as! String, numOfLikes: value.get("numOfLikes") as! Int, audio_length: value.get("audio_length") as! Int, userImage: value.get("userImage") as! String, likes: self.likedList, comments: self.commentList)
            }
        })
    }
    
    // MARK: Add comments by upload ID
    func addComments(uploadID: String, comment: Comments) {
        let commentObj = ["author": comment.author, "userID": comment.userID, "content": comment.content, "image": self.userSettings.userImage, "uuid": comment.uuid]
        db.collectionGroup(Settings.uploadsCollection).whereField("uuid", isEqualTo: uploadID).getDocuments(completion: {(querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let document = querySnapShot?.documents else {
                print("No upload with ID: \(uploadID)")
                return
            }
            
            let commentObjItem = document[0].get("commentList") as? [[String:Any]]
            
            guard var commentObjList = commentObjItem else {
                document[0].reference.updateData(["commentList" : [commentObj]])
                return
            }
            
            commentObjList.append(commentObj)
            document[0].reference.updateData(["commentList" : commentObjList])
        })
        
    }
    
    // MARK: Delete Comments by userID
    func deleteComments(uploadID: String, commentID: String) {
        db.collectionGroup(Settings.uploadsCollection).whereField("uuid", isEqualTo: uploadID).getDocuments(completion: {(querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let document = querySnapShot?.documents else {
                print("No upload with ID: \(uploadID)")
                return
            }
            
            let commentObjItem = document[0].get("commentList") as? [[String:Any]]
            
            if let commentObjList = commentObjItem {
                let filterList = commentObjList.filter { $0["uuid"] as! String != commentID }
                document[0].reference.updateData(["commentList" : filterList])
            }
        })
    }
    
    // MARK: Update likes by uploadID
    func updateLikes(uploadID: String) {
        db.collectionGroup(Settings.uploadsCollection).whereField("uuid", isEqualTo: uploadID).getDocuments(completion: {(querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let document = querySnapShot?.documents else {
                print("No upload with ID: \(uploadID) in liking uploads")
                return
            }
            
            let likeObj = document[0].get("likedList") as? [[String:Any]]
            let likeItem = ["author": self.userSettings.username, "userID": self.userSettings.uuid, "isLiked": true] as [String : Any]
            let numOfLikes = document[0].get("numOfLikes") as! Int
            
            guard var likeObjList = likeObj else {
                print("No like list")
                document[0].reference.updateData(["likedList" : [likeItem]])
                return
            }
            
            let isExisting = likeObjList.filter { $0["userID"] as! String == self.userSettings.uuid}
            let isNotExisting = likeObjList.filter { $0["userID"] as! String != self.userSettings.uuid}
            
            if isExisting.isEmpty {
                likeObjList.append(likeItem)
                document[0].reference.updateData(["likedList" : likeObjList, "numOfLikes": numOfLikes + 1])
            } else {
                document[0].reference.updateData(["likedList" : isNotExisting, "numOfLikes": numOfLikes - 1])
            }
        })
    }
    
}
