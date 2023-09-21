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

    /// Очередь для выполнения операций в асинхронном режиме
    private let queue = DispatchQueue(label: "com.example.fetchQueue", attributes: .concurrent)

    /// Массив ``MyNFT``, полученных в результате запроса
    private var nfts: [MyNFT] = []

    /// Кэш для хранения полученных ``MyNFT``
    private var nftsCache: [String: MyNFT] = [:]

    /// Множество ``OrderNetworkModel/nfts``, которые еще не были загружены
    private var missingIds: Set<String> = []

    /// Замыкание для вызова по завершении операции получения заказа
    private var fetchCompletion: ((Result<[MyNFT], Error>) -> Void)?

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
        for id in ids {
            let request = NFTRequest(id: id)

            queue.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                guard let self else { return }

                self.networkClient.send(
                    request: request,
                    type: NFTNetworkModel.self
                ) { [weak self] result in
                    guard let self else { return }

                    switch result {
                    case .success(let model):
                        let nft = self.convert(from: model)
                        self.nfts.append(nft) // Append the fetched NFT to the nfts array
                        self.nftsCache[id] = nft // Store the fetched NFT in the cache

                        // Check if the fetched NFT was part of missingIds
                        if self.missingIds.contains(id) {
                            self.missingIds.remove(id)
                        }

                        // Complete the fetch if all NFTs have been fetched
                        if self.missingIds.isEmpty, let completion = self.fetchCompletion {
                            completion(.success(self.nfts))
                            self.fetchCompletion = nil
                        }
                    case .failure(let error):
                        if let completion = self.fetchCompletion {
                            completion(.failure(error))
                            self.fetchCompletion = nil
                        }
                    }
                }
            }
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

                self.fetchCompletion = completion
                self.missingIds = Set(ids).subtracting(self.nftsCache.keys)

                if self.missingIds.isEmpty {
                    completion(.success(self.nfts))
                } else {
                    self.fetchNfts(by: Array(self.missingIds), completion: completion)
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
                self.nftsCache.removeAll()
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
