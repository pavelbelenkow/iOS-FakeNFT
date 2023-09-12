//
//  NFTScreenViewModel.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 04.09.2023.
//

import Foundation

final class NFTScreenViewModel {
    //MARK: File Private Properties
    fileprivate let api = "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/"

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
            endpoint: URL(string: "\(api)nft"),
            httpMethod: .get,
            dto: nil
        )
        let nftOrderedRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)orders/1"),
            httpMethod: .get,
            dto: nil
        )
        let nftLikedRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)profile/1"),
            httpMethod: .get,
            dto: nil
        )

        nftQueue.async() {
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
        let getRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)profile/1"),
            httpMethod: .get,
            dto: nil
        )

        var profile = NFTLikedModel(
            name: String(), description: String(), website: String(), likes: [String]()
        )
        var isLiked: Bool = false

        lazy var putRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)profile/1"),
            httpMethod: .put,
            dto: profile
        )

        nftQueue.async {
            self.networkClient.send(
                request: getRequest,
                type: NFTLikedModel.self
            ) { result in
                switch result {
                case .success(let data):
                    profile = data

                    if profile.likes.contains(id) {
                        profile.likes.removeAll(where: { $0 == id })
                    } else {
                        profile.likes.append(id)
                        isLiked = true
                    }

                    self.networkClient.send(request: putRequest) { result in
                        self.mainQueue.async {
                            switch result {
                            case .success( _):
                                if isLiked {
                                    for index in 0..<self.nftCollection.count {
                                        if self.nftCollection[index].id == id {
                                            self.nftCollection[index].isLiked = true
                                        }
                                    }
                                } else {
                                    for index in 0..<self.nftCollection.count {
                                        if self.nftCollection[index].id == id {
                                            self.nftCollection[index].isLiked = false
                                        }
                                    }
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                case.failure(let error):
                    print(error)
                }
                }
        }

    }

    func cartNFT(id: String) {
        let getRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)orders/1"),
            httpMethod: .get,
            dto: nil
        )

        var orderList: NFTOrderedModel = NFTOrderedModel(nfts: [], id: String())
        var isOrdered: Bool = false

        lazy var putRequest: NetworkRequest = {
            let request = NFTRequestModel(
                endpoint: URL(string: "\(api)orders/1"),
                httpMethod: .put,
                dto: orderList
            )
            return request
        }()

        nftQueue.async() {
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

                    self.networkClient.send(request: putRequest) { result in
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
