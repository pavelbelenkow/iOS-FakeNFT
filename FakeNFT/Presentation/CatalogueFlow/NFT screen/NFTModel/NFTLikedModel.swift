//
//  File.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 05.09.2023.
//

import Foundation

struct NFTLikedModel: Codable {
    let name: String
    let description: String
    let website: String
    var likes: [String]
}
