//
//  PostItem.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 22/01/2020.
//

import Foundation

class PostItem: Codable {
    var id: String?
    var author: String?
    var title: String?
    var thumbnail: String?
    var created: TimeInterval?
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
        id = try data.decodeIfPresent(String.self, forKey: .id)
        author = try data.decodeIfPresent(String.self, forKey: .author)
        title = try data.decodeIfPresent(String.self, forKey: .title)
        thumbnail = try data.decodeIfPresent(String.self, forKey: .thumbnail)
        created = try data.decodeIfPresent(TimeInterval.self, forKey: .created)
        numComments = try data.decodeIfPresent(Int.self, forKey: .numComments)
        
        // Decode images
        if let previewContainer = try? data.nestedContainer(keyedBy: CodingKeys.self, forKey: .preview),
            let images = try? previewContainer.decodeIfPresent([PostImages].self, forKey: .images) {
            postImages = images.first?.resolutions
        }
    }
    
    // We only need this to encode the PostItem in UserActivity, to preserve that data.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var dataContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
        try dataContainer.encode(id, forKey: .id)
        try dataContainer.encode(author, forKey: .author)
        try dataContainer.encode(title, forKey: .title)
        try dataContainer.encode(thumbnail, forKey: .thumbnail)
        try dataContainer.encode(created, forKey: .numComments)
        try dataContainer.encode(numComments, forKey: .numComments)
        
        var previewContainer = dataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .preview)
        
        var postImagesArray = [PostImages]()
        let postImagesElement = PostImages()
        postImagesElement.resolutions = postImages
        postImagesArray.append(postImagesElement)
        
        try previewContainer.encode(postImagesArray, forKey: .images)
    }
}

// Just for mapping
private class PostImages: Codable {
    var resolutions: [PostImage]?
}



