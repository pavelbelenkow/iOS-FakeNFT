import Foundation

// MARK: - Protocols

protocol OrderPaymentViewModelProtocol {
    var listCurrencies: [Currency] { get }
    func bindCurrencies(_ completion: @escaping ([Currency]) -> Void)
    func getCurrencies(_ completion: @escaping (Error) -> Void)
}

// MARK: - OrderPaymentViewModel class

final class OrderPaymentViewModel {
    
    // MARK: - Properties
    
    @Observable var currencies: [Currency]
    
    private let orderPaymentService: OrderPaymentServiceProtocol
    
    // MARK: - Initializers
    
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
    
    func getCurrencies(_ completion: @escaping (Error) -> Void) {
        UIBlockingProgressHUD.show()
        
        orderPaymentService.fetchCurrencies { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success(let currencies):
                    self.currencies = currencies
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
}
