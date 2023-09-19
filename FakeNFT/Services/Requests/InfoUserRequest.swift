//
//  InfoUserRequest.swift
//  FakeNFT
//
//  Created by REYNIKOV ANTON on 30.08.2023.
//

import Foundation

struct InfoUserRequest: NetworkRequest {
    let userId: String
    var endpoint: URL? { URL(string: self.baseEndpoint + "users/\(userId)") }

    var httpMethod: HttpMethod { .get }
}
