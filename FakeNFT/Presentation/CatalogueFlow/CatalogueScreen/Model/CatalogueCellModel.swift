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
    let count: Int
    let id: String

    private enum CodingKeys: String, CodingKey {
        case name
        case url = "cover"
        case count = "nfts"
        case id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        print(container)

        self.id = try container.decode(String.self, forKey: .id)

        self.url = try container.decode(String.self, forKey: .url)

        let nfts = try container.decode([String].self, forKey: .count)
        self.count = nfts.count

        self.name = try container.decode(String.self, forKey: .name)
    }
}
