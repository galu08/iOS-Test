//
//  ReadPostAction.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 27/01/2020.
//

import Foundation

final class ReadPostAction {
    
    private var repository: ReadPostsRespository
    
    init(readPostRepository: ReadPostsRespository = ReadPostsRespository()) {
        repository = readPostRepository
    }
    
    func markAsRead(postId: String) {
        repository.insert(postId)
    }
    
    func markAsUnread(postId: String) {
        repository.delete(postId)
    }
    
    func wasRead(postId: String) -> Bool {
        repository.contains(postId)
    }
}
