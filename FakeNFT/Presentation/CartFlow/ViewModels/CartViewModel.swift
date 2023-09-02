import Foundation

// MARK: - Protocols

protocol CartViewModelProtocol {
    var listNfts: [NFT] { get }
    func bindNfts(_ completion: @escaping ([NFT]) -> Void)
    func getOrder(_ completion: @escaping (Error) -> Void)
    func getNftsTotalValue() -> Float
    func removeNft(by id: String, _ completion: @escaping (Error?) -> Void)
    func sortBy(option: SortOption)
}

// MARK: - CartViewModel class

final class CartViewModel {
    
    // MARK: - Properties
    
    @Observable var nfts: [NFT]
    
    private let cartService: CartServiceProtocol
    private var sortOption: SortOption?
    private var sortDirection: SortDirection = .descending
    
    // MARK: - Initializers
    
    init(cartService: CartServiceProtocol = CartService()) {
        self.nfts = []
        self.cartService = cartService
    }
}

// MARK: - Methods

extension CartViewModel: CartViewModelProtocol {
    
    var listNfts: [NFT] { nfts }
    
    func bindNfts(_ completion: @escaping ([NFT]) -> Void) {
        $nfts.bind(action: completion)
    }
    
    func getOrder(_ completion: @escaping (Error) -> Void) {
        UIBlockingProgressHUD.show()
        
        cartService.fetchOrder { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success(let nfts):
                    self.nfts = nfts
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
    func getNftsTotalValue() -> Float {
        var totalValue: Float = 0
        
        nfts.forEach { nft in
            let price = nft.price
            totalValue += price
        }
        
        return totalValue
    }
    
    func removeNft(by id: String, _ completion: @escaping (Error?) -> Void) {
        if let index = nfts.firstIndex(where: { $0.id == id }) {
            nfts.remove(at: index)
            let nfts = nfts.map { $0.id }
            cartService.putOrder(with: nfts) { error in
                completion(error)
            }
        }
    }
    
    func sortBy(option: SortOption) {
        if sortOption == option {
            sortDirection = (sortDirection == .descending) ? .ascending : .descending
        } else {
            sortDirection = .descending
        }
        
        nfts.sort(by: option.compareFunction(sortDirection: sortDirection))
        sortOption = option
    }
}
