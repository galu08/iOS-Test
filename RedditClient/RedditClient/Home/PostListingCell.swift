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
    @IBOutlet weak var readIndicatorView: UIView!
    
    weak var delegate: DeleteableCell?
    
    private var urlToDownload: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        readIndicatorView.layer.cornerRadius = readIndicatorView.frame.size.height * 0.5
    }
    
    func setup(authorName: String?,
               postTitle: String?,
               date: String,
               imageURL: String?,
               commentsCount: String,
               read: Bool) {
        self.authorName.text = authorName
        self.postDate.text = date
        self.postTitle.text = postTitle
        self.commentLabel.text = commentsCount
        
        if let stringURL = imageURL {
            urlToDownload = stringURL
            NetworkService().downloadImage(stringURL: stringURL) { (downloadedURL, data) in
               
                // Check if we are in the right cell
                if let imageData = data, downloadedURL.absoluteString == self.urlToDownload {
                    self.set(image: UIImage(data: imageData), withAnimation: true)
                }
            }
        }
        
        if read {
            setReadStyle()
        } else {
            setUnreadStyle()
        }
    }
    
    private func setReadStyle() {
        postTitle.textColor = UIColor.systemGray4
        postImage.alpha = 0.85
        readIndicatorView.backgroundColor = nil
    }
    
    private func setUnreadStyle() {
        postTitle.textColor = UIColor.systemGray
        postImage.alpha = 1
        readIndicatorView.backgroundColor = UIColor.systemBlue
    }
    
    private func set(image: UIImage?, withAnimation animate: Bool) {
        
        if animate {
            UIView.transition(with: self.postImage,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.postImage.image = image },
                              completion: nil)
        } else {
            self.postImage.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
    }
    
    @IBAction func didPressDelete() {
        delegate?.userDidDelete(cell: self)
    }
}
