//
//  TrackerDbService.swift
//  fbtracker
//
//  Created by Moshe Sivan on 17/03/2017.
//  Copyright © 2017 n72. All rights reserved.
//

import Foundation

class TrackerDbService {
    
    static var posts: [Post]!
    static var matches: [Match]!
    
    static func loadData(completed: @escaping () -> Void) {
        TrackerDbService.posts = [];
        TrackerDbService.matches = [];
        
        var loadedTasks = 0
        
        let postsTask = URLSession.shared.dataTask(with: getCollectionUrl(collectionName: "posts", filter: "&l=1000&s=%7Btime:-1%7D")) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            for case let postJson in json! {
                if let post = Post(json: postJson) {
                    self.posts.append(post)
                }
            }
            
            objc_sync_enter(self)
            loadedTasks = loadedTasks + 1
            if (loadedTasks == 2) {
                completed()
            }
            objc_sync_exit(self)
        }

        let matchesTask = URLSession.shared.dataTask(with: getCollectionUrl(collectionName: "matches")) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            for case let matchJson in json! {
                if let match = Match(json: matchJson) {
                    self.matches.append(match)
                }
            }

            objc_sync_enter(self)
            loadedTasks = loadedTasks + 1
            if (loadedTasks == 2) {
                completed()
            }
            objc_sync_exit(self)
        }

        postsTask.resume()
        matchesTask.resume()
    }
    
    private static func getCollectionUrl(collectionName: String, filter: String = "") -> URL {
        return URL(string: "https://api.mlab.com/api/1/databases/fbtracker/collections/\(collectionName)?apiKey=\(ApiKey.Value)\(filter)")!
    }
}

class Post {
    var id: String
    var match: Bool
    var time: Date
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let match = json["match"] as? Bool,
            let timeJson = json["time"] as? [String: String]
            else {
                return nil
        }
        
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        self.id = id
        self.match = match
        self.time = dateFor.date(from: timeJson["$date"]!)!
    }
}

class Match {
    var id: String
    var link: String
    var text: String
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let link = json["link"] as? String,
            let text = json["text"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.link = link
        self.text = text
    }
}
