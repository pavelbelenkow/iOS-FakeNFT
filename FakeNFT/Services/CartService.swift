import Foundation

// MARK: - Protocols

/**
 Протокол ``CartServiceProtocol`` определяет методы для работы с объектом ``CartService``
 
 ``CartServiceProtocol`` содержит методы для получения списка ``MyNFT`` и отправки заказа
 */
protocol CartServiceProtocol {
    /**
     Получает список ``MyNFT``, необходимых для оформления заказа
     - Parameter completion: Блок кода, который будет выполнен после получения списка ``MyNFT``
     */
    func fetchOrder(_ completion: @escaping (Result<[MyNFT], Error>) -> Void)

    /**
     Отправляет заказ на сервер
     - Parameters:
        - nfts: Массив строк, содержащий ``MyNFT/id``, которые необходимо заказать
        - completion: Блок кода, который будет выполнен после отправки заказа
     */
    func putOrder(with nfts: [String], _ completion: @escaping (Error?) -> Void)
}

// MARK: - CartService class

/**
 Класс ``CartService`` предоставляет методы для получения списка ``MyNFT`` и отправки заказа
 
 ``CartService`` содержит методы для получения списка ``MyNFT`` и отправки заказа с помощью сетевых запросов
 */
final class CartService {

    // MARK: - Properties

    /// Массив ``MyNFT``, полученных в результате запроса
    private var nfts: [MyNFT] = []

    /// Кэш для хранения полученных ``MyNFT``
    private var nftsCache: [String: MyNFT] = [:]

    /// Сетевой клиент для отправки сетевых запросов
    private let networkClient: NetworkClient

    // MARK: - Initializers

    /**
     Инициализирует объект ``CartService``
     - Parameter networkClient: Сетевой клиент для отправки сетевых запросов (необязательный параметр,
     по умолчанию - ``DefaultNetworkClient``)
     */
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - Private methods

private extension CartService {

    /**
     Конвертирует сетевую модель ``NFTNetworkModel`` в модель ``MyNFT`` приложения
     - Parameter model: Сетевая модель
     - Returns: Модель ``MyNFT`` приложения
     */
    func convert(from model: NFTNetworkModel) -> MyNFT {
        MyNFT(
            name: model.name,
            image: model.images[0],
            rating: model.rating,
            price: model.price,
            id: model.id
        )
    }

    /**
     Получает массив ``MyNFT`` по массиву ``OrderNetworkModel/nfts``
     - Parameters:
        - ids: Массив строк, содержащий ``MyNFT/id``, которые необходимо получить
        - completion: Блок кода, который будет выполнен после получения массива ``MyNFT``
     */
    func fetchNfts(by ids: [String], completion: @escaping (Result<[MyNFT], Error>) -> Void) {
        nfts.removeAll()

        let dispatchGroup = DispatchGroup()

        // Filter out already fetched NFT from the ids array
        let missingIds = Set(ids).subtracting(nftsCache.keys)

        for id in missingIds {
            dispatchGroup.enter()
            let request = NFTRequest(id: id)

            networkClient.send(
                request: request,
                type: NFTNetworkModel.self
            ) { [weak self] result in
                defer { dispatchGroup.leave() }
                guard let self else { return }

                switch result {
                case .success(let model):
                    let nft = self.convert(from: model)
                    self.nfts.append(nft) // Append the fetched NFT to the nfts array
                    self.nftsCache[id] = nft // Store the fetched NFT in the cache
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        // Filter out already fetched NFT from the cache
        let cachedNfts = ids.compactMap { nftsCache[$0] }

        // Append the fetched NFT from cache to the nfts array
        nfts.append(contentsOf: cachedNfts)

        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            completion(.success(self.nfts))
        }
    }
}

// MARK: - Methods

extension CartService: CartServiceProtocol {

    func fetchOrder(_ completion: @escaping (Result<[MyNFT], Error>) -> Void) {
        let request = GetOrderRequest()

        networkClient.send(
            request: request,
            type: OrderNetworkModel.self
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let order):
                let ids = order.nfts.map { $0 }

                self.fetchNfts(by: ids) { result in
                    switch result {
                    case .success(let fetchedNfts):
                        completion(.success(fetchedNfts))
                    case .failure:
                        print("Failed to fetch nfts from order")
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func putOrder(with nfts: [String], _ completion: @escaping (Error?) -> Void) {
        var request = PutOrderRequest()
        request.dto = OrderNetworkModel(nfts: nfts)

        networkClient.send(request: request) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.nfts.removeAll()
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
