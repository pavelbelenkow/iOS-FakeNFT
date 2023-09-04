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
    private let nftRequest: NetworkRequest = NFTRequestModel()
    private let nftQueue = DispatchQueue(label: "com.nftScreen.queue", attributes: .concurrent)
    private let mainQueue = DispatchQueue.main

    //MARK: Initialisers
    init(author: String) {
        self.author = author
    }

    //MARK: Internal Methods
    func getNFTCollection() {
        nftQueue.async {
            self.networkClient.send(request: self.nftRequest, type: [NFTModel].self) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let model):
                        self.nftCollection.append(contentsOf: model.filter { $0.author == self.author } )
                    case .failure(let error):
                        preconditionFailure("\(error)")
                    }
                }
            }
        }
    }
}
