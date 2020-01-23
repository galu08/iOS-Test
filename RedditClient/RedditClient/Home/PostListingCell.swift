//
//  PostListingCell.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 22/01/2020.
//

import UIKit

protocol DeleteableCell: class {
    func userDidDelete(cell: UITableViewCell)
}

class PostListingCell: UITableViewCell {
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    weak var delegate: DeleteableCell?
    
    func setup(authorName: String?,
               postTitle: String?,
               date: String,
               imageURL: String,
               commentsCount: String) {
        self.authorName.text = authorName
        self.postDate.text = date
        self.postTitle.text = postTitle
        self.commentLabel.text = commentsCount
        
        // download image
    }
    
    @IBAction func didPressDelete() {
        delegate?.userDidDelete(cell: self)
    }
}
