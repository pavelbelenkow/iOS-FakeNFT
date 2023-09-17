//
//  LikesEditedNetworkService.swift
//  FakeNFT
//
//  Created by D on 13.09.2023.
//

import Foundation

final class LikesEditedNetworkService {
    private let client = DefaultNetworkClient()

    func sendEdited(likes: LikesEdited, completion: @escaping (Result<LikesEdited, Error>) -> Void) {
        let request = LikesEditedRequest(listOfLikes: likes)
        client.send(request: request, type: LikesEdited.self, onResponse: completion)
    }
}
