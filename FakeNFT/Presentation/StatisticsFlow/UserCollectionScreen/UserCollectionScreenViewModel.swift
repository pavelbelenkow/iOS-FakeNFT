//
//  UserCollectionScreenViewModel.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import Foundation

final class UserCollectionScreenViewModel {
    private let client = DefaultNetworkClient()
    
    @Observable
    private(set) var nfts: [NFT] = []
    
    @Observable
    private(set) var isLoading: Bool = false
    
    func getNFTsUser(nfts: [String]) {
        isLoading = true
        getNFTsUser(idNFTs: nfts) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self.nfts = nfts
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setUserNFTsCollectionViewCell(indexRow: Int) -> UserNFTsCollectionViewCellModel {
        if  let imageAddress = nfts[indexRow].images.first,
            let url = URL(string: imageAddress) {
            return UserNFTsCollectionViewCellModel(
                name: nfts[indexRow].name,
                image: url,
                rating: nfts[indexRow].rating,
                price: nfts[indexRow].price,
                id: nfts[indexRow].id
            )
        }
        
        return UserNFTsCollectionViewCellModel(
            name: String(),
            image: URL(fileURLWithPath: String()),
            rating: Int(),
            price: Double(),
            id: String()
        )
    }
    
    private func getNFTsUser(
        idNFTs: [String],
        completion: @escaping (Result<[NFT], Error>) -> Void
    ) {
        var nfts: [NFT] = []
        let group = DispatchGroup()
        
        idNFTs.forEach { idNFT in
            group.enter()
            let request = ListUserNFTRequest(idNFT: idNFT)
            client.send(
                request: request,
                type: NFT.self
            ) { result in
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
}

