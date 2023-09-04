//
//  CatalogueViewModel.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 31.08.2023.
//

import Foundation

final class CatalogueViewModel {
    //MARK: Private Properties
    @Observable
    private(set) var catalogue: [CatalogueCellModel] = []

    private let networkClient: NetworkClient = DefaultNetworkClient()
    private let catalogueRequest: NetworkRequest = CatalogueRequestModel()
    private let catalogueQueue = DispatchQueue(label: "com.catalogue.queue", attributes: .concurrent)
    private let mainQueue = DispatchQueue.main

    //MARK: Internal Methods
    func getCatalogue() {
        catalogueQueue.async {
            self.networkClient.send(
                request: self.catalogueRequest,
                type: [CatalogueCellModel].self
            ) { result in
                self.mainQueue.async {
                    switch result {
                    case .success(let model):
                        self.catalogue = model
                    case .failure(let error):
                        preconditionFailure("Error - \(error)")
                    }
                }
            }
        }

    }
}
