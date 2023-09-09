import Foundation

// MARK: - Protocols

protocol OrderPaymentServiceProtocol {
    func fetchCurrencies(_ completion: @escaping (Result<[Currency], Error>) -> Void)
    func fetchOrderPaymentResult(by currencyId: String, _ completion: @escaping (Result<Bool, Error>) -> Void)
}

// MARK: - OrderPaymentService class

final class OrderPaymentService {
    
    // MARK: - Properties
    
    private let decoder = JSONDecoder()
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - Private methods

private extension OrderPaymentService {
    
    func convert(from model: CurrencyNetworkModel) -> Currency {
        Currency(
            title: model.title,
            name: model.name,
            image: model.image,
            id: model.id
        )
    }
}

// MARK: - Methods

extension OrderPaymentService: OrderPaymentServiceProtocol {
    
    func fetchCurrencies(_ completion: @escaping (Result<[Currency], Error>) -> Void) {
        let request = CurrenciesRequest()
        
        networkClient.send(request: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let currencyModels = try self.decoder.decode([CurrencyNetworkModel].self, from: data)
                    let currencies = currencyModels.map { self.convert(from: $0) }
                    completion(.success(currencies))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchOrderPaymentResult(by currencyId: String, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        let request = OrderPaymentResultRequest(id: currencyId)
        
        networkClient.send(request: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let resultModel = try self.decoder.decode(PaymentResultNetworkModel.self, from: data)
                    let isSuccessResult = resultModel.success
                    completion(.success(isSuccessResult))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
