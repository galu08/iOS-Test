//
//  PostItem.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 22/01/2020.
//

import Foundation

class PostItem: Decodable {
    var id: String?
    var author: String?
    var title: String?
    var thumbnail: String?
    var created: Double?
    var postImages: [PostImage]?
    var numComments: Int?
    
    private enum CodingKeys: String, CodingKey {
        case data
        case id
        case author
        case title
        case thumbnail
        case created
        case preview
        case resolutions
        case numComments = "num_comments"
        case images
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let data = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        id = try data.decodeIfPresent(String.self, forKey: .author)
        author = try data.decodeIfPresent(String.self, forKey: .author)
        title = try data.decodeIfPresent(String.self, forKey: .title)
        thumbnail = try data.decodeIfPresent(String.self, forKey: .thumbnail)
        created = try data.decodeIfPresent(Double.self, forKey: .created)
        numComments = try data.decodeIfPresent(Int.self, forKey: .numComments)
        
        // Decode images
        if let previewContainer = try? data.nestedContainer(keyedBy: CodingKeys.self, forKey: .preview),
            let images = try? previewContainer.decodeIfPresent([PostImages].self, forKey: .images) {
            postImages = images.first?.resolutions
        }
    }
}

// Just for mapping
private class PostImages: Decodable {
    var resolutions: [PostImage]?
}



