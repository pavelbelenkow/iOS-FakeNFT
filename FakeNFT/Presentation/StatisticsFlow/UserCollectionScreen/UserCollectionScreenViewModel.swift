//
//  UserCollectionScreenViewModel.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import Foundation

final class UserCollectionScreenViewModel {
    private let listUserNFTNetReqService = ListUserNFTNetworkRequestService()
    
    @Observable
    private(set) var nfts: [NFT] = []
    
    @Observable
    private(set) var isLoading: Bool = false
    
    func getNFTsUser(nfts: [String]) {
        isLoading = true
        listUserNFTNetReqService.getNFTsUser(idNFTs: nfts) { [weak self] result in
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
        if let url = URL(string: nfts[indexRow].images[0]) {
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
}

