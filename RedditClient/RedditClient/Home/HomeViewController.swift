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
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        let refreshPostsControl = UIRefreshControl()
        refreshPostsControl.addTarget(self, action: #selector(refreshPosts(_:)), for: .valueChanged)
        refreshControl = refreshPostsControl
    }
    
    private func addDeleteAllButton() {
        let deleteAllButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAllPosts(_:)))
        navigationItem.rightBarButtonItem = deleteAllButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    @objc func refreshPosts(_ sender: Any) {
        viewModel.downloadTopPosts()
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
        
        let postImages = post.postImages ?? []
        let smallerImageURL = getSmallerImageURL(images: postImages)
        let wasRead = viewModel.wasRead(index: indexPath.row)
        
        cell.setup(authorName: post.author,
                   postTitle: post.title,
                   date: getHoursAgo(fromDateCreated: post.created),
                   imageURL: smallerImageURL,
                   commentsCount: "\(post.numComments ?? 0 )",
                   read: wasRead)
        
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willShowPost(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

//MARK:- Helpers
extension HomeViewController {
    
    private func getSmallerImageURL(images: [PostImage]) -> String? {
        return images.last?.url
    }
    
    /// Returns the time difference in hours from the given time until now.
    /// - Parameter time: Time interval to calculate
    private func getHoursAgo(fromDateCreated time: TimeInterval?) -> String {
        guard let time = time else { return "-" }
        
        let from = Date(timeIntervalSince1970: time)
        let unitFlags = Set<Calendar.Component>([.hour])
        let components = Calendar.current.dateComponents(unitFlags, from: from, to: Date())
        let hours = components.hour ?? 0
        
        return String(format: NSLocalizedString("HOURS_AGO", comment:"hours from now"), hours)
    }
}


//MARK:- DeleteableCell
extension HomeViewController: DeleteableCell {
    
    func userDidDelete(cell: UITableViewCell) {
        guard let indexPathToDelete = tableView.indexPath(for: cell) else { return }
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPathToDelete], with: .automatic)
        viewModel.removePost(at: indexPathToDelete.row)
        tableView.endUpdates()
    }
}

//MARK:- HomeViewModelListener
extension HomeViewController: HomeViewModelListener {
    
    func didFinishDownloadPosts() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
}
