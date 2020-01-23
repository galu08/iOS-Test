//
//  DetailViewController.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 22/01/2020.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postImageView: UIImageView!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            
            if let label = postDescription {
                label.text = detail.title
            }
            
            if let imageView = postImageView {
                setupImage()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    var detailItem: PostItem? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    private func setupImage() {
        guard let stringURL = detailItem?.postImages?.last?.url else { return }
        
        NetworkService().downloadImage(stringURL: stringURL) { (downloadedURL, data) in
            if let imageData = data, downloadedURL.absoluteString == stringURL {
                self.postImageView.image = UIImage(data: imageData)
            }
        }
    }
}

