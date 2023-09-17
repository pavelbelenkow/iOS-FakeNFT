<<<<<<< HEAD
import Foundation

/**
 Структура `NFTRequest` представляет объект запроса для получения NFT по id
 
 Содержит свойства для формирования запроса на получение NFT по id
 */
struct NFTRequest: NetworkRequest {

    /// Идентификатор NFT, который необходимо получить
    let id: String

    /// URL-адрес конечной точки запроса
    var endpoint: URL? { URL(string: "\(baseEndpoint)nft/\(id)") }

    /// HTTP-метод запроса
    var httpMethod: HttpMethod = .get
=======
//
//  NFTRequest.swift
//  FakeNFT
//
//  Created by D on 05.09.2023.
//

import Foundation

struct NFTRequest: NetworkRequest {
    let id: Int

    init(id: Int) {
        self.id = id
    }
    var endpoint: URL? {
        get {
            URL(string: ("\(baseEndpoint)nft/\(id)"))
        }
    }

    var httpMethod: HttpMethod {
        get {
            .get
        }
    }
>>>>>>> epic_profile
}
