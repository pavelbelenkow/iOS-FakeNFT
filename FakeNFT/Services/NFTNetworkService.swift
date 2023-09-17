//
//  NFTNetworkService.swift
//  FakeNFT
//
//  Created by D on 05.09.2023.
//

import Foundation

final class NFTNetworkService {
    private let client = DefaultNetworkClient()

    func getNFT(id: Int, completion: @escaping (Result<NFTModel, Error>) -> Void) {
        let request = NFTRequest(id: id)
        client.send(request: request, type: NFTModel.self, onResponse: completion)
    }
}
