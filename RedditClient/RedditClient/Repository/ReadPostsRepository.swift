//
//  ReadPostsRepository.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 23/01/2020.
//

import Foundation
import UIKit

class ReadPostsRespository {
    
    init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    private lazy var postsId: Set<String> = {
        guard let array = UserDefaults.standard.array(forKey: "read_posts") as? [String] else { return Set() }
        return Set(array)
    }()
    
   @objc func appMovedToBackground() {
        persistData()
    }
    
    func insert(_ postId: String) {
        postsId.insert(postId)
    }
    
    func contains(_ postId: String) -> Bool {
        return postsId.contains(postId)
    }
    
    func delete(_ postId: String) {
        postsId.remove(postId)
    }
    
    private func persistData() {
        UserDefaults.standard.set(Array(postsId), forKey: "read_posts")
    }
}
