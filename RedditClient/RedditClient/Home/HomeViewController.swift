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
        cell.setup(authorName: post.author,
                   postTitle: post.title,
                   date: "",
                   imageURL: "",
                   commentsCount: "\(post.numComments ?? 0 )")
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: DeleteableCell {
    
    func userDidDelete(cell: UITableViewCell) {
        guard let indexPathToDelete = tableView.indexPath(for: cell) else { return }
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPathToDelete], with: .automatic)
        objects.remove(at: indexPathToDelete.row)
        tableView.endUpdates()
    }
}

