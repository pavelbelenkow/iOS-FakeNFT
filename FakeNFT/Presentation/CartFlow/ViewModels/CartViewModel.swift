import Foundation

// MARK: - Protocols

/**
``CartViewModelProtocol`` определяет интерфейс для работы с моделью(``CartViewModel``) корзины
 
Содержит свойства и методы для получения списка ``MyNFT``, удаления ``MyNFT``, очистки корзины и т.д.
*/
protocol CartViewModelProtocol {

    /// Вычисляемое свойство с актуальными ``MyNFT`` в заказе
    var listNfts: [MyNFT] { get }

    /**
     Привязывает замыкание к изменению списка ``MyNFT`` в корзине
     - Parameter completion: Замыкание, которое вызывается при изменении списка ``MyNFT`` в корзине
     */
    func bindNfts(_ completion: @escaping ([MyNFT]) -> Void)

    /**
     Получает заказ
     - Если запрос завершился успешно, возвращает отсортированный список ``MyNFT`` в корзине
     - Если запрос завершился неудачно, показывает сообщение об ошибке
     */
    func getOrder()

    /**
     Получает общую стоимость ``MyNFT`` в корзине
     - Returns: Общая стоимость ``MyNFT`` в корзине
     */
    func getNftsTotalValue() -> Float

    /**
     Удаляет ``MyNFT`` из корзины
     - Parameters:
        - id: ``MyNFT/id`` удаляемого ``MyNFT``
        - completion: Замыкание, которое вызывается при завершении удаления ``MyNFT`` из корзины
            - Если удаление прошло успешно, возвращает `nil`
            - Если удаление завершилось неудачно, возвращает ошибку
     */
    func removeNft(by id: String, _ completion: @escaping (Error?) -> Void)

    /// Очищает корзину c заказом
    func clearCart()

    /**
     Сортирует ``MyNFT`` в корзине
     - Parameter option: Тип ``SortOption`` сортировки
     */
    func sortBy(option: SortOption)
}

// MARK: - CartViewModel class

/**
``CartViewModel`` - это вью-модель корзины
 
Cодержит методы для работы с корзиной, такие как получение заказа, удаление ``MyNFT`` из корзины, очистка корзины и т.д.
*/
final class CartViewModel {

    // MARK: - Properties

    /// Наблюдаемое свойство списка ``MyNFT`` в корзине
    @Observable var nfts: [MyNFT]

    /// Сетевой сервис корзины
    private let cartService: CartServiceProtocol

    /// Менеджер хранения ``SortOption`` и ``SortDirection`` сортировки
    private let sortStorageManager: SortStorageManager

    // MARK: - Initializers

    /**
     Создает новый объект ``CartViewModel`` с указанным сервисом корзины
     - Parameter cartService: Сетевой сервис корзины (необязательный параметр, по умолчанию - ``CartService``)
     */
    init(cartService: CartServiceProtocol = CartService()) {
        self.nfts = []
        self.cartService = cartService
        self.sortStorageManager = .shared
    }
}

// MARK: - Private methods

private extension CartViewModel {

    /**
     Сортирует ``MyNFT`` в соответствии с текущим типом и направлением сортировки
     
     По умолчанию, если не был ранее установлен тип и направление сортировки, она будет произведена по ``SortDirection/ascending`` и по ``SortOption/name`` ``MyNFT``
     - Parameter nfts: Список ``MyNFT``, который нужно отсортировать
     - Returns: Отсортированный список ``MyNFT``
     */
    func sortNfts(_ nfts: [MyNFT]) -> [MyNFT] {
        let sortOption = sortStorageManager.sortOption
        let sortDirection = sortStorageManager.sortDirection

        return nfts.sorted(by: sortOption.compareFunction(sortDirection: sortDirection))
    }
}

// MARK: - Methods

extension CartViewModel: CartViewModelProtocol {

    var listNfts: [MyNFT] { nfts }

    func bindNfts(_ completion: @escaping ([MyNFT]) -> Void) {
        $nfts.bind(action: completion)
    }

    func getOrder() {
        UIBlockingProgressHUD.show()

        cartService.fetchOrder { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {

                switch result {
                case .success(let nfts):
                    let sortedNfts = self.sortNfts(nfts)
                    self.nfts = sortedNfts
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.showFailed(with: Constants.Cart.failedToFetchCart)
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
        guard let index = nfts.firstIndex(where: { $0.id == id }) else {
            return
        }

        let nftsIds = nfts
            .filter { $0.id != id }
            .map { $0.id }

        cartService.putOrder(with: nftsIds) { error in
            DispatchQueue.main.async {
                if let error {
                    completion(error)
                } else {
                    self.nfts.remove(at: index)
                    completion(nil)
                }
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
