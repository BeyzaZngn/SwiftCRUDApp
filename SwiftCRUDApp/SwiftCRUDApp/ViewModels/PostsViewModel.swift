//
//  PostsViewModel.swift
//  SwiftCRUDApp
//
//  Created by Beyza Zengin on 1.10.2025.
//

import Foundation

protocol PostsViewModelDelegate: AnyObject {
    func didUpdatePosts()
    func didFailWithError(_ error: String)
}

final class PostsViewModel {
    weak var delegate: PostsViewModelDelegate?
    private let service: APIServiceProtocol
    private(set) var posts: [Post] = []

    init(service: APIServiceProtocol = APIService()) { self.service = service }

    func loadPosts() {
        service.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list): self?.posts = list; self?.delegate?.didUpdatePosts()
                case .failure(let e): self?.delegate?.didFailWithError(e.localizedDescription)
                }
            }
        }
    }

    func addPost(title: String, body: String) {
        let new = Post(id: nil, userId: 1, title: title, body: body)
        service.createPost(new) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let created): self?.posts.insert(created, at: 0); self?.delegate?.didUpdatePosts()
                case .failure(let e): self?.delegate?.didFailWithError(e.localizedDescription)
                }
            }
        }
    }

    func updatePost(_ post: Post) {
        service.updatePost(post) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updated):
                    if let i = self?.posts.firstIndex(where: { $0.id == updated.id }) {
                        self?.posts[i] = updated
                    }
                    self?.delegate?.didUpdatePosts()
                case .failure(let e): self?.delegate?.didFailWithError(e.localizedDescription)
                }
            }
        }
    }

    func deletePost(at index: Int) {
        guard let id = posts[index].id else { return }
        service.deletePost(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success: self?.posts.remove(at: index); self?.delegate?.didUpdatePosts()
                case .failure(let e): self?.delegate?.didFailWithError(e.localizedDescription)
                }
            }
        }
    }
}
