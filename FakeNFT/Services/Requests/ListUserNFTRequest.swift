//
//  ListUserNFTRequest.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import Foundation

struct ListUserNFTRequest: NetworkRequest {
    let idNFT: String
    var endpoint: URL? {
        get {
            URL(string: self.baseEndpoint + "nft/\(idNFT)")
        }
    }

    var httpMethod: HttpMethod {
        get {
            .get
        }
    }
}
