import Foundation

// MARK: - Protocols

/**
 Протокол ``OrderPaymentServiceProtocol`` определяет методы для работы с объектом ``OrderPaymentService``
 
 ``OrderPaymentServiceProtocol`` содержит методы для получения списка валют и результата оплаты заказа
 */
protocol OrderPaymentServiceProtocol {
    
    /**
     Получает список валют для оплаты
     - Parameter completion: Блок кода, который будет выполнен после получения списка валют
     */
    func fetchCurrencies(_ completion: @escaping (Result<[Currency], Error>) -> Void)
    
    /**
     Проверка результатов оплаты заказа
     - Parameters:
        - currencyId: ``Currency/id`` валюты
        - completion: Блок кода, который будет выполнен после получения результата оплаты заказа(``PaymentResultNetworkModel/success``)
     */
    func fetchOrderPaymentResult(by currencyId: String, _ completion: @escaping (Result<Bool, Error>) -> Void)
}

// MARK: - OrderPaymentService class

/**
 Класс ``OrderPaymentService`` предоставляет методы для получения списка валют и результата оплаты заказа
 
 ``OrderPaymentService`` содержит методы для получения списка валют и результата оплаты заказа с помощью сетевых запросов
 */
final class OrderPaymentService {
    
    // MARK: - Properties
    
    /// Декодер для декодирования данных в формате JSON
    private let decoder = JSONDecoder()
    
    /// Сетевой клиент для отправки сетевых запросов
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    
    /**
     Инициализирует объект ``OrderPaymentService``
     - Parameter networkClient: Сетевой клиент для отправки сетевых запросов (необязательный параметр, по умолчанию - ``DefaultNetworkClient``)
     */
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}

// MARK: - Private methods

private extension OrderPaymentService {
    
    /**
     Конвертирует сетевую модель ``CurrencyNetworkModel`` в модель приложения ``Currency``
     - Parameter model: Сетевая модель валюты
     - Returns: Модель валюты приложения
     */
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
