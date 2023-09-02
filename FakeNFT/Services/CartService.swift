import Foundation

// MARK: - Protocols

protocol CartServiceProtocol {
    var nfts: [NFT] { get }
    func fetchOrder(_ completion: @escaping (Result<[NFT], Error>) -> Void)
    func putOrder(with nfts: [String], _ completion: @escaping (Error?) -> Void)
}

// MARK: - CartService class

final class CartService {
    
    // MARK: - Properties
    
    private let decoder = JSONDecoder()
    private(set) var nfts: [NFT] = []
    
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - Private methods

private extension CartService {
    
    func convert(from model: NFTNetworkModel) -> NFT {
        NFT(
            name: model.name,
            image: model.images[0],
            rating: model.rating,
            price: model.price,
            id: model.id
        )
    }
    
    func fetchNfts(by ids: [String], completion: @escaping (Result<[NFT], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var nfts: [NFT] = []
        
        for id in ids {
            dispatchGroup.enter()
            let request = NFTRequest(id: id)
            
            networkClient.send(request: request) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    do {
                        let model = try self.decoder.decode(NFTNetworkModel.self, from: data)
                        let nft = self.convert(from: model)
                        nfts.append(nft)
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(nfts))
            self.nfts.removeAll()
        }
    }
}

// MARK: - Methods

extension CartService: CartServiceProtocol {
    
    func fetchOrder(_ completion: @escaping (Result<[NFT], Error>) -> Void) {
        let request = GetOrderRequest()
        
        networkClient.send(request: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let order = try self.decoder.decode(OrderNetworkModel.self, from: data)
                    let ids = order.nfts.map { $0 }
                    
                    self.fetchNfts(by: ids) { result in
                        switch result {
                        case .success(let fetchedNfts):
                            self.nfts.append(contentsOf: fetchedNfts)
                            completion(.success(self.nfts))
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
                DispatchQueue.main.async {
                    self.nfts.removeAll()
                }
                
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
