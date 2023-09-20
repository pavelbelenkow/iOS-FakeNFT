import Foundation

// MARK: - Protocols

/**
``OrderPaymentViewModelProtocol`` определяет интерфейс для работы с моделью(``OrderPaymentViewModel``) оплаты заказа
 
 Содержит свойства и методы для получения списка ``Currency``, получения результата оплаты заказа(``PaymentResultNetworkModel/success``) и т.д.
*/
protocol OrderPaymentViewModelProtocol {

    /// Вычисляемое свойство с актуальным списком валют
    var listCurrencies: [Currency] { get }

    /**
     Привязывает замыкание к изменению списка валют для оплаты
     - Parameter completion: Замыкание, которое вызывается при изменении списка валют
     */
    func bindCurrencies(_ completion: @escaping ([Currency]) -> Void)

    /**
     Получает список валют для оплаты
     - Если запрос завершился успешно, возвращает список валют
     - Если запрос завершился неудачно, возвращает сообщение об ошибке
     */
    func getCurrencies()

    /**
     Получает результат оплаты заказа.
     - Parameters:
        - currencyId: ``Currency/id`` валюты
        - completion: Замыкание, которое вызывается при завершении запроса на получение результата оплаты заказа:
            - Если запрос завершился успешно, возвращает результат оплаты заказа(``PaymentResultNetworkModel/success``)
            - Если запрос завершился неудачно, возвращает ошибку
     */
    func getOrderPaymentResult(by currencyId: String, _ completion: @escaping (Result<Bool, Error>) -> Void)

    /**
     Обрабатывает результата оплаты заказа
     - Parameter isSuccess: Результат оплаты заказа(``PaymentResultNetworkModel/success``)
     */
    func handlePaymentResult(_ isSuccess: Bool)
}

// MARK: - OrderPaymentViewModel class

/**
``OrderPaymentViewModel`` - это вью-модель оплаты заказа
 
Cодержит методы для работы с оплатой заказа, такие как получение списка валют, получение результата оплаты заказа и т.д.
*/
final class OrderPaymentViewModel {

    // MARK: - Properties

    /// Наблюдаемое свойство списка валют для оплаты
    @Observable var currencies: [Currency]

    /// Сетевой сервис оплаты заказа
    private let orderPaymentService: OrderPaymentServiceProtocol

    /// Обработчик результата оплаты заказа
    var paymentResultHandler: ((Bool) -> Void)?

    // MARK: - Initializers

    /**
     Создает новый объект ``OrderPaymentViewModel`` с указанным сервисом оплаты заказа
     - Parameter cartService: Сетевой сервис оплаты заказа (необязательный параметр, по умолчанию - ``OrderPaymentService``)
     */
    init(orderPaymentService: OrderPaymentServiceProtocol = OrderPaymentService()) {
        self.currencies = []
        self.orderPaymentService = orderPaymentService
    }
}

// MARK: - Methods

extension OrderPaymentViewModel: OrderPaymentViewModelProtocol {

    var listCurrencies: [Currency] { currencies }

    func bindCurrencies(_ completion: @escaping ([Currency]) -> Void) {
        $currencies.bind(action: completion)
    }

    func getCurrencies() {
        UIBlockingProgressHUD.show()

        orderPaymentService.fetchCurrencies { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {

                switch result {
                case .success(let currencies):
                    self.currencies = currencies
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.showFailed(with: Constants.Cart.failedToFetchCurrencies)
                }
            }
        }
    }

    func getOrderPaymentResult(by currencyId: String, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        UIBlockingProgressHUD.show()

        orderPaymentService.fetchOrderPaymentResult(by: currencyId) { result in

            DispatchQueue.main.async {

                switch result {
                case .success(let isSuccess):
                    completion(.success(isSuccess))
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func handlePaymentResult(_ isSuccess: Bool) {
        paymentResultHandler?(isSuccess)
    }
}
