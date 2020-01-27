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
    
    var detailItem: PostItem?
    
    /// Returns the userActivity object with the information we want to preserve. In this case the postItem object.
    ///
    /// Important: We shouldn't preserve the whole object, instead we should preserve the ID and then get the object from backend.
    var detailUserActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: "com.RedditClient")
        if let detail = detailItem, let detailData = try? JSONEncoder().encode(detail) {
            userActivity.addUserInfoEntries(from: ["postItem": detailData])
        }
        return userActivity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        // Update the user interface for the detail item.
        guard let detail = detailItem  else { return }
        
        if let label = postDescription {
            label.text = detail.title
        }
        
        setupImage()
    }
    
    private func setupImage() {
        guard let stringURL = detailItem?.postImages?.last?.url else { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveImage(_:)))
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.isUserInteractionEnabled = true
        
        NetworkService().downloadImage(stringURL: stringURL) { [weak self] (downloadedURL, data) in
            if let imageData = data, downloadedURL.absoluteString == stringURL {
                self?.postImageView.image = UIImage(data: imageData)
            }
        }
    }
}

//MARK:- Save Image
extension DetailViewController {
    
    @objc func saveImage(_ gesture: Any) {
        guard let image = postImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            showAlert(title: "Save Error ❗️", message: "We couln't save you photo, please try again")
        } else {
            showAlert(title: "Saved 👌", message: "Your image has been saved to your photos.")
        }
    }
    
    private func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
