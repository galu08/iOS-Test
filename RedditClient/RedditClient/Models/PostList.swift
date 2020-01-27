//
//  PostList.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 22/01/2020.
//

import Foundation

class PostList: Decodable {
    var posts: [PostItem]? = nil
    var after: String?
    var before: String?
    
    private enum CodingKeys: String, CodingKey {
        case data
        case children
        case after
        case before
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        let items = try data.decodeIfPresent([PostItem].self, forKey: .children)
        posts = items
        after = try data.decodeIfPresent(String.self, forKey: .after)
        before = try data.decodeIfPresent(String.self, forKey: .before)
    }
}
