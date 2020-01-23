//
//  MasterViewController.swift
//  RedditClient
//
//  Created by OLX - Gonzalo Alu on 22/01/2020.
//

import UIKit

class HomeViewController: UITableViewController {

    private var detailViewController: DetailViewController? = nil
    private let viewModel: HomeViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = HomeViewModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewModel.listener = self
    }
    
    required init?(coder: NSCoder) {
        viewModel = HomeViewModel()
        super.init(coder: coder)
        viewModel.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDeleteAllButton()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        viewModel.downloadTopPosts()
    }
    
    private func addDeleteAllButton() {
        let deleteAllButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAllPosts(_:)))
        navigationItem.rightBarButtonItem = deleteAllButton
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = viewModel.getPost(at: indexPath.row)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }
}

// MARK:- Actions
extension HomeViewController {
    
    @objc func removeAllPosts(_ sender: Any) {
        tableView.beginUpdates()
        for idx in 0..<viewModel.getNumberOfPosts() {
            tableView.deleteRows(at: [IndexPath(row: idx, section: 0)], with: .automatic)
        }
        viewModel.removeAllPosts()
        tableView.endUpdates()
    }
}

// MARK:- TableView Delegate & DataSource
extension HomeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfPosts()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostListingCell", for: indexPath) as? PostListingCell,
        let post = viewModel.getPost(at: indexPath.row) else {
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
        viewModel.removePost(at: indexPathToDelete.row)
        tableView.endUpdates()
    }
}

extension HomeViewController: HomeViewModelListener {
    
    func didFinishDownloadPosts() {
        tableView.reloadData()
    }
    
}
