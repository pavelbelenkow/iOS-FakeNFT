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
    private let nftQueue = DispatchQueue(label: "com.nftScreen.queue", attributes: .concurrent)
    private let mainQueue = DispatchQueue.main

    //MARK: Initialisers
    init(author: String) {
        self.author = author
    }

    //MARK: Internal Methods
    func getNFTCollection() {
        let nftRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(
                string: "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/nft"
            ),
            httpMethod: .get,
            dto: nil
        )
        let nftOrderedRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(
                string: "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/orders/1"
            ),
            httpMethod: .get,
            dto: nil
        )
        let nftLikedRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(
                string: "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/profile/1"
            ),
            httpMethod: .get,
            dto: nil
        )

        nftQueue.async(flags: .barrier) {
            self.networkClient.send(
                request: nftRequest,
                type: [NFTModel].self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let model):
                        self.nftCollection.append(
                            contentsOf: model.filter { $0.author == self.author }
                        )

                        self.networkClient.send(
                            request: nftOrderedRequest,
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
                            request: nftLikedRequest,
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
                    case .failure(let error):
                        preconditionFailure("\(error)")
                    }
                }
            }
        }
    }

    func addNFTToFavourites(id: String) {

    }

    func cartNFT(id: String) {
        let getRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(
                string: "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/orders/1"
            ),
            httpMethod: .get,
            dto: nil
        )

        var orderList: NFTOrderedModel = NFTOrderedModel(nfts: [], id: String())
        var isOrdered: Bool = false

        lazy var orderPutRequest: NetworkRequest = {
            let request = NFTRequestModel(
                endpoint: URL(
                    string: "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/orders/1"
                ),
                httpMethod: .put,
                dto: orderList
            )
            return request
        }()

        nftQueue.async(flags: .barrier) {
            self.networkClient.send(
                request: getRequest,
                type: NFTOrderedModel.self
            ) { result in
                switch result {
                case .success(let data):
                    orderList = data

                    if orderList.nfts.contains(id) {
                        orderList.nfts.removeAll(where: { $0 == id })
                    } else {
                        orderList.nfts.append(id)
                        isOrdered = true
                    }

                    self.networkClient.send(request: orderPutRequest) { result in
                        self.mainQueue.async {
                            switch result {
                            case .success( _):
                                if isOrdered {
                                    for index in 0..<self.nftCollection.count {
                                        if self.nftCollection[index].id == id {
                                            self.nftCollection[index].isOrdered = true
                                        }
                                    }
                                } else {
                                    for index in 0..<self.nftCollection.count {
                                        if self.nftCollection[index].id == id {
                                            self.nftCollection[index].isOrdered = false
                                        }
                                    }
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                }
        }
    }
}
