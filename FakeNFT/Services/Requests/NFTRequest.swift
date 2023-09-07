//
//  NFTRequest.swift
//  FakeNFT
//
//  Created by D on 05.09.2023.
//

import Foundation

struct NFTRequest: NetworkRequest {
    let id: Int

    init(id: Int) {
        self.id = id
    }
    var endpoint: URL? {
        get {
            URL(string: ("\(baseEndpoint)nft/\(id)"))
        }
    }

    var httpMethod: HttpMethod {
        get {
            .get
        }
    }
}
