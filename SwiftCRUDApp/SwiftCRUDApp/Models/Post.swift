//
//  Post.swift
//  SwiftCRUDApp
//
//  Created by Beyza Zengin on 30.09.2025.
//

import Foundation

struct Post: Codable {
    let id: String?    // MongoDB ObjectId
    let userId: Int?
    var title: String
    var body: String

    // Maps the backend JSON keys (e.g. "_id") to the Swift property names for Codable conformance:
    private enum CodingKeys: String, CodingKey { case id = "_id", userId, title, body }
}
