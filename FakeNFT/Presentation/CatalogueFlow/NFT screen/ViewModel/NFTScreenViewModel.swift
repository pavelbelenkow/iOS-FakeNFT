//
//  NFTScreenViewModel.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 04.09.2023.
//

import Foundation

final class NFTScreenViewModel {
    // MARK: File Private Properties
    fileprivate let api = "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/"

    // MARK: Private Properties
    @Observable
    private(set) var nftCollection: [NFTModel] = []

    @Observable
    private(set) var authorName = String()

    private let author: String
    private let networkClient: NetworkClient = DefaultNetworkClient()
    private let nftQueue = DispatchQueue(label: "com.nftScreen.queue", attributes: .concurrent)
    private let mainQueue = DispatchQueue.main

    // MARK: Initialisers
    init(author: String) {
        self.author = author
    }

    // MARK: Internal Methods
    func getNFTCollection(completion: @escaping (Result<Void, Error>) -> Void) {
        fetchNFTCollectionData { result in
            switch result {
            case .success(let model):
                self.fetchOrderedNFTs(nftCollection: model) { result in
                    switch result {
                    case .success(let model):
                        self.fetchLikedNFTs(nftCollection: model) { result in
                            switch result {
                            case .success(let model):
                                self.nftCollection = model
                                completion(.success(()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addNFTToFavourites(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchFavouritesModel(id: id) { result in
            switch result {
            case .success(let model):
                self.sendFavourites(favouritesModel: model, id: id) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    func cartNFT(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchOrders(id: id) { result in
            switch result {
            case .success(let model):
                self.sendOrders(id: id, ordersModel: model) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getAuthorName(
        withID id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let getRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)users/\(id)"),
            httpMethod: .get,
            dto: nil
        )

        nftQueue.async {
            self.networkClient.send(
                request: getRequest,
                type: AuthorModel.self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let data):
                        self.authorName = data.name
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

// MARK: Private Methods
private extension NFTScreenViewModel {
    func fetchNFTCollectionData(
        completion: @escaping (Result<[NFTModel], Error>) -> Void
    ) {
        let request: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)nft"),
            httpMethod: .get,
            dto: nil
        )

        nftQueue.async {
            self.networkClient.send(
                request: request,
                type: [NFTModel].self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let model):
                        completion(.success(model.filter({ $0.author == self.author })))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func fetchOrderedNFTs(
        nftCollection: [NFTModel],
        completion: @escaping (Result<[NFTModel], Error>) -> Void
    ) {
        let request: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)orders/1"),
            httpMethod: .get,
            dto: nil
        )

        nftQueue.async {
            self.networkClient.send(
                request: request,
                type: NFTOrderedModel.self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let model):
                        var collection = nftCollection
                        for index in 0..<collection.count {
                            if model.nfts.contains(collection[index].id) {
                                collection[index].isOrdered = true
                            }
                        }
                        completion(.success(collection))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func fetchLikedNFTs(
        nftCollection: [NFTModel],
        completion: @escaping (Result<[NFTModel], Error>) -> Void
    ) {
        let request: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)profile/1"),
            httpMethod: .get,
            dto: nil
        )

        nftQueue.async {
            self.networkClient.send(
                request: request,
                type: NFTLikedModel.self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let model):
                        var collection = nftCollection
                        for index in 0..<collection.count {
                            if model.likes.contains(collection[index].id) {
                                collection[index].isLiked = true
                            }
                        }
                        completion(.success(collection))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func fetchFavouritesModel(
        id: String,
        completion: @escaping (Result<FetchFavouritesModel, Error>) -> Void
    ) {
        let getRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)profile/1"),
            httpMethod: .get,
            dto: nil
        )

        var favouritesModel = FetchFavouritesModel(
            profile: NFTLikedModel(
                name: String(), description: String(), website: String(), likes: [String]()
            ),
            isLiked: false
        )

        nftQueue.async {
            self.networkClient.send(
                request: getRequest,
                type: NFTLikedModel.self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let data):
                        favouritesModel.profile = data

                        if favouritesModel.profile.likes.contains(id) {
                            favouritesModel.profile.likes.removeAll(where: { $0 == id })
                        } else {
                            favouritesModel.profile.likes.append(id)
                            favouritesModel.isLiked = true
                        }
                        completion(.success(favouritesModel))
                    case.failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func sendFavourites(
        favouritesModel: FetchFavouritesModel,
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let putRequest: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)profile/1"),
            httpMethod: .put,
            dto: favouritesModel.profile
        )

        nftQueue.async {
            self.networkClient.send(request: putRequest) { result in
                self.mainQueue.async {
                    switch result {
                    case .success:
                        if favouritesModel.isLiked {
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
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func fetchOrders(
        id: String,
        completion: @escaping (Result<FetchOrdersModel, Error>) -> Void
    ) {
        let request: NetworkRequest = NFTRequestModel(
            endpoint: URL(string: "\(api)orders/1"),
            httpMethod: .get,
            dto: nil
        )

        var ordersModel = FetchOrdersModel(
            orderList: NFTOrderedModel(nfts: [], id: String()),
            isOrdered: false
        )

        nftQueue.async {
            self.networkClient.send(
                request: request,
                type: NFTOrderedModel.self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let data):
                        ordersModel.orderList = data

                        if ordersModel.orderList.nfts.contains(id) {
                            ordersModel.orderList.nfts.removeAll(where: { $0 == id })
                        } else {
                            ordersModel.orderList.nfts.append(id)
                            ordersModel.isOrdered = true
                        }

                        completion(.success(ordersModel))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func sendOrders(
        id: String,
        ordersModel: FetchOrdersModel,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let request: NetworkRequest = {
            let request = NFTRequestModel(
                endpoint: URL(string: "\(api)orders/1"),
                httpMethod: .put,
                dto: ordersModel.orderList
            )
            return request
        }()

        nftQueue.async {
            self.networkClient.send(request: request) { result in
                self.mainQueue.async {
                    switch result {
                    case .success:
                        if ordersModel.isOrdered {
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
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
