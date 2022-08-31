//
//  PodcastViewModel.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 31/08/2022.
//

import Foundation
import FirebaseFirestore

class PodcastViewModel: ObservableObject {
    @Published var podcasts = [Podcasts]()
    @Published var categories = [Categories]()
    
    private var db = Firestore.firestore()
    
    // MARK: fetching podcasts API with 20 documents with categories
    func fetchPodcasts(categories: [String]) {
        db.collection(Settings.podcastsCollection).whereField("categories", arrayContainsAny: categories).limit(to: 20).getDocuments(completion: {querySnapShot, error in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            guard let documents = querySnapShot?.documents else {
                print("No data")
                return
            }
            
            self.podcasts = documents.map {(queryDocumentSnapshot) -> Podcasts in
                let author = queryDocumentSnapshot.get("author") as! String
                let categories = queryDocumentSnapshot.get("categories") as! [String]
                let description = queryDocumentSnapshot.get("description") as! String
                let image = queryDocumentSnapshot.get("image") as! String
                let itunes_id = queryDocumentSnapshot.get("itunes_id") as! Int32
                let language = queryDocumentSnapshot.get("language") as! String
                let title = queryDocumentSnapshot.get("title") as! String
                let uuid = queryDocumentSnapshot.get("uuid") as! String
                let website = queryDocumentSnapshot.get("website") as! String
                let episodes = queryDocumentSnapshot.get("episodes") as! [[String: Any]]
                
                let episodeObj = episodes.map {(value) -> Episodes in
                    let audio = value["audio"] as! String
                    let audio_length = value["audio_length"] as! Int
                    let episode_description = value["description"] as! String
                    let episode_uuid = value["episode_uuid"] as! String
                    let podcast_uuid = value["podcast_uuid"] as! String
                    let pub_date = value["pub_date"] as! String
                    let episode_title = value["title"] as! String
                    return Episodes(audio: audio, audio_length: audio_length, description: episode_description, episode_uuid: episode_uuid, podcast_uuid: podcast_uuid, pub_date: pub_date, title: episode_title)
                }
                
                return Podcasts(uuid: uuid, author: author, description: description, image: image, itunes_id: itunes_id, language: language, title: title, website: website, categories: categories, episodes: episodeObj)
            }
        })
    }
    
    // MARK: fetch all categories
    func fetchCategories() {
        db.collection(Settings.categoriesCollection).getDocuments(completion: {querySnapShot, error in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            guard let documents = querySnapShot?.documents else {
                print("No data")
                return
            }
            
            self.categories = documents.map {(documentSnapShot) -> Categories in
                let categories = documentSnapShot.get("categories") as! String
                return Categories(categories: categories)
            }
        })
    }
    
}
