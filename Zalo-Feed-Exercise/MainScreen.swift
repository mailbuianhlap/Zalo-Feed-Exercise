//
//  MainScreen.swift
//  Zalo-Feed-Exercise
//
//  Created by Bui Anh Lap on 30/05/2022.
//

import Foundation
import UIKit

class MainScreen : UIViewController {
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let viewModel = PhotosListViewModel()
    var shouldShowLoadMoreView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadData()
    }
    private func setupUI() {
        title = "Gallery"
    }
    
    private func setupTableView() {
        tableViewOutlet.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        tableViewOutlet.register(UINib(nibName: "LoadMoreView", bundle: nil), forHeaderFooterViewReuseIdentifier: "LoadMoreView")
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
    }
    
    private func loadData() {
        viewModel.fetchPhotos { [weak self] _ in
            self?.tableViewOutlet.reloadData()
            self?.loadingIndicator.stopAnimating()
        }
    }
    
    private func likeOrUnlikePhoto(at index: Int) {
        viewModel.likeOrUnlikePhoto(at: index) { [weak self] in
            self?.tableViewOutlet.reloadData()
        }
    }
    
    private func loadMore() {
        guard !viewModel.isLoadMore else { return }
        shouldShowLoadMoreView = true
        tableViewOutlet.reloadData()
        viewModel.loadMore { [weak self] in
            self?.shouldShowLoadMoreView = false
            self?.tableViewOutlet.reloadData()
        }
    }
}
extension MainScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableViewOutlet: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        if let photo = viewModel.photo(at: indexPath.row) {
            cell.configure(photo) { [weak self] in
                self?.likeOrUnlikePhoto(at: indexPath.row)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photos.count - 1 { // Trigger load more when scroll to last item
            loadMore()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        shouldShowLoadMoreView ? 60 : 0
    }
}
