//
//  CatalogueRequestModel.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 04.09.2023.
//

import Foundation

struct CatalogueRequestModel: NetworkRequest {
    var endpoint: URL? = {
        guard let url = URL(
            string: "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/collections"
        ) else { return nil }

        return url
    }()
    var httpMethod: HttpMethod = .get
    var dto: Encodable? = nil
}
