//
//  PostViewController.swift
//  SwiftCRUDApp
//
//  Created by Beyza Zengin on 30.09.2025.
//

import UIKit

final class PostsViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = PostsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Posts"; view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewPost))
        setupTableView()
        viewModel.delegate = self
        viewModel.loadPosts()
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    @objc private func addNewPost() {
        let addVC = AddPostViewController()
        addVC.onSave = { [weak self] title, body in self?.viewModel.addPost(title: title, body: body) }
        navigationController?.pushViewController(addVC, animated: true)
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.posts.count }

    func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let p = viewModel.posts[ip.row]
        cell.textLabel?.text = p.title
        cell.detailTextLabel?.text = p.body
        return cell
    }

    func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath) {
        let editVC = EditPostViewController()
        editVC.post = viewModel.posts[ip.row]
        editVC.onSave = { [weak self] updated in self?.viewModel.updatePost(updated) }
        navigationController?.pushViewController(editVC, animated: true)
    }

    func tableView(_ tv: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { viewModel.deletePost(at: indexPath.row) }
    }
}

extension PostsViewController: PostsViewModelDelegate {
    func didUpdatePosts() { tableView.reloadData() }
    func didFailWithError(_ error: String) { print("Hata:", error) }
}
