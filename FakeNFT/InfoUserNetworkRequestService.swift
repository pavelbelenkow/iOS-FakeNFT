//
//  InfoUserNetworkRequestService.swift
//  FakeNFT
//
//  Created by REYNIKOV ANTON on 30.08.2023.
//

import Foundation

final class InfoUserNetworkRequestService {
    private let client = DefaultNetworkClient()
    
    func getInfoUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        let request = InfoUserRequest(userId: userId)
        client.send(request: request, type: User.self, onResponse: completion)
    }
}
