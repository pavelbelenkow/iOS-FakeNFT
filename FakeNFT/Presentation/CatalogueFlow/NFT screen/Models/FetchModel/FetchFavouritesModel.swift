//
//  FavouritesModel.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 12.09.2023.
//

import Foundation

struct FetchFavouritesModel: Codable {
    var profile: NFTLikedModel
    var isLiked: Bool
}
