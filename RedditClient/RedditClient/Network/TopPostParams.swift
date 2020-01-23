//
//  TopPostParams.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 23/01/2020.
//

import Foundation

struct TopPostParams {
    var after: String = ""
    var count: String = ""
    var limit: Int = 20
    var jsonEncoded: Bool = false
    
    var asURLQueryItems: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        if !after.isEmpty {
            queryItems.append(URLQueryItem(name: "after", value: after))
        }
        
        if !count.isEmpty {
            queryItems.append(URLQueryItem(name: "count", value: count))
        }
        
        if limit > 0 {
            queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        
        if !jsonEncoded {
            queryItems.append(URLQueryItem(name: "raw_json", value: "1"))
        }
        
        return queryItems
    }
}
