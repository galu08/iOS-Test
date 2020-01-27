//
//  HomeViewModel.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 22/01/2020.
//

import Foundation

protocol HomeViewModelable: class {
    func getNumberOfPosts() -> Int
    func getTopPosts() -> [PostItem]
    func getPost(at index: Int) -> PostItem?
    func removePost(at index: Int)
    func removeAllPosts()
    func didSelect(index: Int)
    func wasRead(index: Int) -> Bool
}

protocol HomeViewModelListener: class {
    func didFinishDownloadPosts()
}

final class HomeViewModel: HomeViewModelable {
    
    private var postItems = [PostItem]()
    private var readPostAction = ReadPostAction()
    
    weak var listener: HomeViewModelListener?
    
    func downloadTopPosts() {
        let params = TopPostParams()
        NetworkService().getTopPosts(params: params, completion: { [weak self] topPost in
            
            guard let posts = topPost?.posts else { return }
            self?.postItems = posts
            self?.listener?.didFinishDownloadPosts()
        })
    }
    
    func getNumberOfPosts() -> Int {
        return postItems.count
    }
    
    func getTopPosts() -> [PostItem] {
        return postItems
    }
    
    func getPost(at index: Int) -> PostItem? {
        if !postItems.indices.contains(index) { return nil }
        return postItems[index]
    }
    
    func removePost(at index: Int) {
        postItems.remove(at: index)
    }
    
    func removeAllPosts() {
        postItems.removeAll()
    }
    
    func didSelect(index: Int) {
        guard let postId = postItems[index].id else { return }
        readPostAction.markAsRead(postId: postId)
    }
    
    func wasRead(index: Int) -> Bool {
        guard let postId = postItems[index].id else { return false }
        return readPostAction.wasRead(postId: postId)
    }
}
