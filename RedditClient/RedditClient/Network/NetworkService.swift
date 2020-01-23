//
//  NetworkService.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 22/01/2020.
//

import Foundation

class NetworkService {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getTopPosts(params: TopPostParams, completion: @escaping (PostList?) -> Void) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: APIEnpoints.top) {
            urlComponents.queryItems = params.asURLQueryItems
            
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer { self?.dataTask = nil }
                
                if let error = error {
                    print(error.localizedDescription)
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    do {
                        let postList = try JSONDecoder().decode(PostList.self, from: data)
                        DispatchQueue.main.async {
                            completion(postList)
                        }
                    } catch let e {
                        print(e)
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
    
    func downloadImage(stringURL: String, completion: @escaping (URL, Data?) -> Void) {
        guard let url = URLComponents(string: stringURL)?.url else { return }
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer { self?.dataTask = nil }
            
            if let error = error {
                print(error.localizedDescription)
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    completion(url, data)
                }
            }
        }
        
        dataTask?.resume()
    }
}

class APIEnpoints {
    
    static let top = "https://www.reddit.com/top.json"
}
