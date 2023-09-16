import Foundation

// MARK: - Protocols

/**
 Протокол ``CartServiceProtocol`` определяет методы для работы с объектом ``CartService``
 
 ``CartServiceProtocol`` содержит методы для получения списка ``NFT`` и отправки заказа
 */
protocol CartServiceProtocol {
    /**
     Получает список ``NFT``, необходимых для оформления заказа
     - Parameter completion: Блок кода, который будет выполнен после получения списка ``NFT``
     */
    func fetchOrder(_ completion: @escaping (Result<[NFT], Error>) -> Void)

    /**
     Отправляет заказ на сервер
     - Parameters:
        - nfts: Массив строк, содержащий ``NFT/id``, которые необходимо заказать
        - completion: Блок кода, который будет выполнен после отправки заказа
     */
    func putOrder(with nfts: [String], _ completion: @escaping (Error?) -> Void)
}

// MARK: - CartService class

/**
 Класс ``CartService`` предоставляет методы для получения списка ``NFT`` и отправки заказа
 
 ``CartService`` содержит методы для получения списка ``NFT`` и отправки заказа с помощью сетевых запросов
 */
final class CartService {

    // MARK: - Properties

    /// Декодер для декодирования данных в формате JSON
    private let decoder = JSONDecoder()

    /// Массив ``NFT``, полученных в результате запроса
    private var nfts: [NFT] = []

    /// Кэш для хранения полученных ``NFT``
    private var nftsCache: [String: NFT] = [:]

    /// Сетевой клиент для отправки сетевых запросов
    private let networkClient: NetworkClient

    // MARK: - Initializers

    /**
     Инициализирует объект ``CartService``
     - Parameter networkClient: Сетевой клиент для отправки сетевых запросов (необязательный параметр, по умолчанию - ``DefaultNetworkClient``)
     */
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - Private methods

private extension CartService {

    /**
     Конвертирует сетевую модель ``NFTNetworkModel`` в модель ``NFT`` приложения
     - Parameter model: Сетевая модель
     - Returns: Модель ``NFT`` приложения
     */
    func convert(from model: NFTNetworkModel) -> NFT {
        NFT(
            name: model.name,
            image: model.images[0],
            rating: model.rating,
            price: model.price,
            id: model.id
        )
    }

    /**
     Получает массив ``NFT`` по массиву ``OrderNetworkModel/nfts``
     - Parameters:
        - ids: Массив строк, содержащий ``NFT/id``, которые необходимо получить
        - completion: Блок кода, который будет выполнен после получения массива ``NFT``
     */
    func fetchNfts(by ids: [String], completion: @escaping (Result<[NFT], Error>) -> Void) {
        nfts.removeAll()

        let dispatchGroup = DispatchGroup()

        // Filter out already fetched NFT from the ids array
        let missingIds = Set(ids).subtracting(nftsCache.keys)

        for id in missingIds {
            dispatchGroup.enter()
            let request = NFTRequest(id: id)

            networkClient.send(request: request) { [weak self] result in
                defer { dispatchGroup.leave() }
                guard let self else { return }

                switch result {
                case .success(let data):
                    do {
                        let model = try self.decoder.decode(NFTNetworkModel.self, from: data)
                        let nft = self.convert(from: model)
                        self.nfts.append(nft) // Append the fetched NFT to the nfts array
                        self.nftsCache[id] = nft // Store the fetched NFT in the cache
                    } catch {
                        completion(.failure(error))
                    }
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

    func fetchOrder(_ completion: @escaping (Result<[NFT], Error>) -> Void) {
        let request = GetOrderRequest()

        networkClient.send(request: request) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let data):
                do {
                    let order = try self.decoder.decode(OrderNetworkModel.self, from: data)
                    let ids = order.nfts.map { $0 }

                    self.fetchNfts(by: ids) { result in
                        switch result {
                        case .success(let fetchedNfts):
                            completion(.success(fetchedNfts))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } catch {
                    completion(.failure(error))
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
