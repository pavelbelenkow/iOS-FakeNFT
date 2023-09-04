//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 04.09.2023.
//

import Foundation

struct NFTModel: Decodable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let author: String
    let id: String
}
