//
//  ListUsersRequest.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import Foundation

struct ListUsersRequest: NetworkRequest {
    var endpoint: URL? { URL(string: self.baseEndpoint + "users") }

    var httpMethod: HttpMethod { .get }
}
