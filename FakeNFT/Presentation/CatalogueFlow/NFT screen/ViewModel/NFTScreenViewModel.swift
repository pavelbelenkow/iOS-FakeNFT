//
//  NFTScreenViewModel.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 04.09.2023.
//

import Foundation

final class NFTScreenViewModel {
    //MARK: Private Properties
    @Observable
    private(set) var nftCollection: [NFTModel] = []

    private let author: String
    private let networkClient: NetworkClient = DefaultNetworkClient()
    private let nftRequest: NetworkRequest = NFTRequestModel(
        endpoint: URL(
            string: "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/nft"
        ),
        httpMethod: .get,
        dto: nil
    )
    private let nftOrderedRequest: NetworkRequest = NFTRequestModel(
        endpoint: URL(
            string: "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/orders/1"
        ),
        httpMethod: .get,
        dto: nil
    )
    private let nftLikedRequest: NetworkRequest = NFTRequestModel(
        endpoint: URL(
            string: "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/profile/1"
        ),
        httpMethod: .get,
        dto: nil
    )
    private let nftQueue = DispatchQueue(label: "com.nftScreen.queue", attributes: .concurrent)
    private let mainQueue = DispatchQueue.main

    //MARK: Initialisers
    init(author: String) {
        self.author = author
    }

    //MARK: Internal Methods
    func getNFTCollection() {
        nftQueue.async(flags: .barrier) {
            self.networkClient.send(
                request: self.nftRequest,
                type: [NFTModel].self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let model):
                        self.nftCollection.append(
                            contentsOf: model.filter { $0.author == self.author }
                        )
                    case .failure(let error):
                        preconditionFailure("\(error)")
                    }
                }
            }

            self.networkClient.send(
                request: self.nftOrderedRequest,
                type: NFTOrderedModel.self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let model):
                        for index in 0..<self.nftCollection.count {
                            if model.nfts.contains(self.nftCollection[index].id) {
                                self.nftCollection[index].isOrdered = true
                            }
                        }
                    case .failure(let error):
                        print("Error - \(error)")
                    }
                }
            }

            self.networkClient.send(
                request: self.nftLikedRequest,
                type: NFTLikedModel.self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let model):
                        for index in 0..<self.nftCollection.count {
                            if model.likes.contains(self.nftCollection[index].id) {
                                self.nftCollection[index].isLiked = true
                            }
                        }
                    case .failure(let error):
                        print("Error - \(error)")
                    }
                }
            }
        }
    }
}
