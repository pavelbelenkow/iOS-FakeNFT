//
//  FetchOrdersModel.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 12.09.2023.
//

import Foundation

struct FetchOrdersModel: Codable {
    var orderList: NFTOrderedModel
    var isOrdered: Bool
}
