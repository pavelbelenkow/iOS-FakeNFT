//
//  ListUsersNetworkRequestService.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import Foundation

final class ListUsersNetworkRequestService {
    private let client = DefaultNetworkClient()
    private let request = ListUsersRequest()
    
    func getListUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        client.send(request: request, type: [User].self, onResponse: completion)
    }
}
