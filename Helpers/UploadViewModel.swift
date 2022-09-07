//
//  UploadViewModel.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 07/09/2022.
//

import Foundation
import FirebaseFirestore

class UploadViewModel: ObservableObject {
    @Published var uploads = [Uploads]()
    @Published var upload = Uploads(uuid: "", title: "", description: "", audioPath: "", author: "", pub_date: "", image: "", language: "", userID: "", numOfLikes: 0, likes: [], comments: [])
    @Published var lastDocumentSnapshot: DocumentSnapshot!
    @Published var fetchingMore = false
    
    private var db = Firestore.firestore()
    
    // MARK: create a upload
    func addUploads() {
        var ref: DocumentReference?
        ref = db.collection(Settings.uploadsCollection).addDocument(data: [
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
            "commentList": []
        ]) { error in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
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
                        
                        let newUploads = Uploads(uuid: value.get("uuid") as! String, title: value.get("title") as! String, description: value.get("description") as! String, audioPath: value.get("audio") as! String, author: value.get("author") as! String, pub_date: value.get("pub_date") as! String, image: value.get("image") as! String, language: value.get("language") as! String, userID: value.get("user_id") as! String, numOfLikes: value.get("numOfLikes") as! Int, likes: likedObj, comments: commentObj)
                        self.uploads.append(newUploads)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.fetchingMore = false
                    })

                    self.lastDocumentSnapshot = snapshot!.documents.last
                }
            }
    }
}
