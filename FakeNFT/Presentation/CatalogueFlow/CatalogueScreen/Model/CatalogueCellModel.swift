//
//  CatalogueCellModel.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 31.08.2023.
//

import Foundation

struct CatalogueCellModel: Decodable {
    let name: String
    let url: String
    let nfts: [String]
    let description: String
    var author: String
    let id: String

    private enum CodingKeys: String, CodingKey {
        case name
        case url = "cover"
        case nfts
        case description
        case author
        case id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.url = try container.decode(String.self, forKey: .url)
        self.nfts = try container.decode([String].self, forKey: .nfts)
        self.description = try container.decode(String.self, forKey: .description)
        self.author = try container.decode(String.self, forKey: .author)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
