//
//  ReadPostsRepository.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 23/01/2020.
//

import Foundation

class ReadPostsRespository {
    
    private lazy var postsId: Set<String> = {
        guard let array = UserDefaults.standard.array(forKey: "read_posts") as? [String] else { return Set() }
        return Set(array)
    }()
    
    deinit {
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
