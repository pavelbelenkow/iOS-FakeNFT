//
//  User.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import Foundation

struct User: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
