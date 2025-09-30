//
//  APIService.swift
//  SwiftCRUDApp
//
//  Created by Beyza Zengin on 30.09.2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void)
    func createPost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void)
    func updatePost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void)
    func deletePost(id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class APIService: APIServiceProtocol {
    // For the iOS simulator, localhost works. Use the Mac IP on the physical device: "http://192.168.x.x:3000"
    private let baseURL = "http://127.0.0.1:3000"

    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts") else { return }
        NetworkManager.shared.request(URLRequest(url: url), completion: completion)
    }

    func createPost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(post)
        NetworkManager.shared.request(req, completion: completion)
    }

    func updatePost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let id = post.id, let url = URL(string: "\(baseURL)/posts/\(id)") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(post)
        NetworkManager.shared.request(req, completion: completion)
    }

    func deletePost(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/\(id)") else { return }
        var req = URLRequest(url: url); req.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: req) { _, _, err in
            if let err = err { completion(.failure(err)) } else { completion(.success(())) }
        }.resume()
    }
}
