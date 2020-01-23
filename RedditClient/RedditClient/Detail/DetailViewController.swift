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
                self.title = detail.title
            }
            
            if let imageView = postImageView {
                //download image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: PostItem? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

