//
//  ListLikedNFTRequest.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 08.09.2023.
//

import Foundation

struct ListLikedNFTRequest: NetworkRequest {
    var endpoint: URL? {
        get {
            URL(string: self.baseEndpoint + "profile/1")
        }
    }

    var httpMethod: HttpMethod {
        get {
            .get
        }
    }
}
