import Foundation

// MARK: - Protocols

protocol CartViewModelProtocol {
    var listNfts: [NFT] { get }
    func bindNfts(_ completion: @escaping ([NFT]) -> Void)
    func getOrder(_ completion: @escaping (Error) -> Void)
    func getNftsTotalValue() -> Float
    func removeNft(by id: String, _ completion: @escaping (Error?) -> Void)
    func clearCart()
    func sortBy(option: SortOption)
}

// MARK: - CartViewModel class

final class CartViewModel {
    
    // MARK: - Properties
    
    @Observable var nfts: [NFT]
    
    private let cartService: CartServiceProtocol
    private let sortStorageManager: SortStorageManager
    
    // MARK: - Initializers
    
    init(cartService: CartServiceProtocol = CartService()) {
        self.nfts = []
        self.cartService = cartService
        self.sortStorageManager = .shared
    }
}

// MARK: - Private methods

private extension CartViewModel {
    
    func sortNfts(_ nfts: [NFT]) -> [NFT] {
        let sortOption = sortStorageManager.sortOption
        let sortDirection = sortStorageManager.sortDirection
        
        return nfts.sorted(by: sortOption.compareFunction(sortDirection: sortDirection))
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
                    let sortedNfts = self.sortNfts(nfts)
                    self.nfts = sortedNfts
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
    
    func clearCart() {
        nfts.removeAll()
        cartService.putOrder(with: []) { _ in }
    }
    
    func sortBy(option: SortOption) {
        if sortStorageManager.sortOption == option {
            sortStorageManager.sortDirection = (sortStorageManager.sortDirection == .ascending) ? .descending : .ascending
        } else {
            sortStorageManager.sortDirection = .ascending
        }
        
        nfts.sort(by: option.compareFunction(sortDirection: sortStorageManager.sortDirection))
        sortStorageManager.sortOption = option
    }
}
