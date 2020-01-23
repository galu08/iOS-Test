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
}

protocol HomeViewModelListener: class {
    func didFinishDownloadPosts()
}

final class HomeViewModel: HomeViewModelable {
    
    private var postItems = [PostItem]()
    
    weak var listener: HomeViewModelListener?
    
    func downloadTopPosts() {
        NetworkService().getTopPosts(completion: { [weak self] topPost in
            
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
}
