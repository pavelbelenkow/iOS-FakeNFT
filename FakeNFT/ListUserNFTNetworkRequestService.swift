//
//  ListUserNFTNetworkRequestService.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import Foundation

final class ListUserNFTNetworkRequestService {
    private let client = DefaultNetworkClient()
    
    func getNFTsUser(idNFTs: [String], completion: @escaping (Result<[NFT], Error>) -> Void) {
        var nfts: [NFT] = []
        let group = DispatchGroup()
        
        idNFTs.forEach { idNFT in
            group.enter()
            getNFTUser(idNFT: idNFT) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(.success(nfts))
        }
    }
    
    private func getNFTUser(idNFT: String, completion: @escaping (Result<NFT, Error>) -> Void) {
        let request = ListUserNFTRequest(idNFT: idNFT)
        client.send(request: request, type: NFT.self, onResponse: completion)
    }
}
