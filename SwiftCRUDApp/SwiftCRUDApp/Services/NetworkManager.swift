//
//  NetworkManager.swift
//  SwiftCRUDApp
//
//  Created by Beyza Zengin on 30.09.2025.
//

import Foundation

enum NetworkError: Error { case invalidURL, invalidResponse, decodingError }

final class NetworkManager { // This class handles all HTTP requests in the application.
    static let shared = NetworkManager();
    private init() {}

    func request<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let err = error {
                completion(.failure(err));
                return
            }
            
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode
            else {
                completion(.failure(NetworkError.invalidResponse));
                return
            }
            
            guard let data = data
            else { completion(.failure(NetworkError.decodingError));
                return
            }
            
            do { let decoded = try JSONDecoder().decode(T.self, from: data); completion(.success(decoded))
            }catch { completion(.failure(error))
            }
        }.resume()
    }
}
