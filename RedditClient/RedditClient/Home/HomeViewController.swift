//
//  MasterViewController.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 22/01/2020.
//

import UIKit

class HomeViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [PostItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let deleteAllButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAllPosts(_:)))
        navigationItem.rightBarButtonItem = deleteAllButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        NetworkService().getTopPosts(completion: { topPost in
            
            guard let posts = topPost?.posts else { return }
            self.objects = posts
            self.tableView.reloadData()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func removeAllPosts(_ sender: Any) {

        tableView.beginUpdates()
        for idx in 0..<objects.count {
            tableView.deleteRows(at: [IndexPath(row: idx, section: 0)], with: .automatic)
        }
        objects.removeAll()
        tableView.endUpdates()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = objects[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostListingCell", for: indexPath) as? PostListingCell,
            let post = objects[indexPath.row] as? PostItem  else {
            return UITableViewCell()
        }
        
        cell.postTitle.text = post.title
        cell.authorName.text = post.author
        cell.commentLabel.text = "\(post.numComments ?? 0 )"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

