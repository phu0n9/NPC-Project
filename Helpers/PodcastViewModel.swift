//
//  PodcastViewModel.swift
//  NPC
//
//  Created by Nguyen Huynh Phuong Anh on 31/08/2022.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import AVFoundation
import AVKit

class PodcastViewModel: ObservableObject {
    @Published var podcasts = [Podcasts]()
    @Published var randomPodcasts = [Podcasts]()
    @Published var categories = [Categories]()
    @Published var episodes = [Episodes]()
    @Published var paginatedEpisodes = [Episodes]()
    @Published var podcast = Podcasts(uuid: "", author: "", description: "", image: "", itunes_id: 0, language: "", title: "", website: "", categories: [], episodes: [])
    @Published var episode = Episodes(audio: "", audio_length: 0, description: "", episode_uuid: "", podcast_uuid: "", pub_date: "", title: "", image: "", user_id: "", isLiked: false)
    
    private var db = Firestore.firestore()
    private var userSettings = UserSettings()
    @Published var isFetchingMore = false
    private var isDoneDownloading = false
    
    // MARK: fetching podcasts API with x documents with categories
    func fetchPodcasts(categories: [String], isRandom: Bool) {
        if !isRandom {
            db.collection(Settings.podcastsCollection).limit(to: 10).whereField("categories", arrayContainsAny: categories).getDocuments(completion: {querySnapShot, error in
                if let err = error {
                    print("Error getting documents: \(err)")
                }
                
                guard let documents = querySnapShot?.documents else {
                    print("No data")
                    return
                }
                
                self.getPodcastByQuerySnapShot(documents: documents, isRandom: isRandom)
            })
        } else {
            let randomStr = String(Int.random(in: 0..<10))
            db.collection(Settings.podcastsCollection).limit(to: 10)
                .order(by: "uuid")
                .start(at: [randomStr])
                .getDocuments(completion: {querySnapShot, error in
                    if let err = error {
                        print("Error getting documents: \(err)")
                    }
                    
                    guard let documents = querySnapShot?.documents else {
                        print("No data")
                        return
                    }
                    
                    self.getPodcastByQuerySnapShot(documents: documents, isRandom: isRandom)
                })
        }
    }
    
    // MARK: get podcast by query snap shot document
    func getPodcastByQuerySnapShot(queryDocumentSnapshot: DocumentSnapshot, episodeId: String, isRandom: Bool) -> Podcasts {
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
            let episodeObjId = value["episode_uuid"] as! String
            let episode = Episodes(audio: value["audio"] as! String, audio_length: value["audio_length"] as! Int, description: value["description"] as! String, episode_uuid: episodeObjId, podcast_uuid: value["podcast_uuid"] as! String, pub_date: value["pub_date"] as! String, title: value["title"] as! String, image: value["episode_image"] as! String, user_id: "", isLiked: false)
            if episodeObjId == episodeId {
                self.episode = episode
            }
            if !isRandom {
                self.episodes.append(episode)
            }
            return episode
        }
        
        return Podcasts(uuid: uuid, author: author, description: description, image: image, itunes_id: itunes_id, language: language, title: title, website: website, categories: categories, episodes: episodeObj)
    }
    
    // MARK: assign podcasts
    func getPodcastByQuerySnapShot(documents: [DocumentSnapshot], isRandom: Bool) {
        if !isRandom {
            self.podcasts = documents.map {(queryDocumentSnapshot) -> Podcasts in
                return getPodcastByQuerySnapShot(queryDocumentSnapshot: queryDocumentSnapshot, episodeId: "", isRandom: isRandom)
            }
            self.paginateEpisodes()
        } else {
            self.randomPodcasts = documents.map {(queryDocumentSnapshot) -> Podcasts in
                return getPodcastByQuerySnapShot(queryDocumentSnapshot: queryDocumentSnapshot, episodeId: "", isRandom: isRandom)
            }
            //            self.paginateEpisodes()
        }
    }
    
    // MARK: append pagination episodes
    func paginateEpisodes() {
        self.isFetchingMore = true
        guard !self.episodes.isEmpty else {
            return
        }
        
        guard self.paginatedEpisodes.count < self.episodes.count else {
            return
        }
        
        if self.paginatedEpisodes.count + 5 < self.episodes.count {
            addPaginationList(start: self.paginatedEpisodes.count, end: self.paginatedEpisodes.count + 5)
        } else {
            addPaginationList(start: self.paginatedEpisodes.count, end: self.episodes.count)
            self.isFetchingMore = false
        }
    }
    
    // MARK: add pagination episode list
    func addPaginationList(start: Int, end: Int) {
        for i in start..<end {
            self.paginatedEpisodes.append(self.episodes[i])
        }
    }
    
    // MARK: get podcast by id
    func fetchPodcastById(podcastId: String, episodeId: String) {
        db.collection(Settings.podcastsCollection).document(podcastId).getDocument(completion: { (querySnapShot, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            
            guard let document = querySnapShot else {
                print("No document with ID: \(podcastId)")
                return
            }
            
            self.podcast = self.getPodcastByQuerySnapShot(queryDocumentSnapshot: document, episodeId: episodeId, isRandom: false)
            self.episodes = self.podcast.episodes
            self.paginateEpisodes()
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
            
            self.isDoneDownloading = true
        })
    }
    
    // MARK: search title by keyword
    func searchByTitle(keyword: String) {
        db.collection(Settings.podcastsCollection).whereField("title_lowercase", in: [keyword.lowercased()]).getDocuments(completion: { (querySnapShot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            }
            guard let documents = querySnapShot?.documents else {
                print("No data")
                return
            }
            self.getPodcastByQuerySnapShot(documents: documents, isRandom: true)
        })
    }
}
