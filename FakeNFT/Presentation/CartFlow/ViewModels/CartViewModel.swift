import Foundation

// MARK: - Protocols

/**
``CartViewModelProtocol`` определяет интерфейс для работы с моделью(``CartViewModel``) корзины
 
Содержит свойства и методы для получения списка ``NFT``, удаления ``NFT``, очистки корзины и т.д.
*/
protocol CartViewModelProtocol {

    /// Вычисляемое свойство с актуальными ``NFT`` в заказе
    var listNfts: [NFT] { get }

    /**
     Привязывает замыкание к изменению списка ``NFT`` в корзине
     - Parameter completion: Замыкание, которое вызывается при изменении списка ``NFT`` в корзине
     */
    func bindNfts(_ completion: @escaping ([NFT]) -> Void)

    /**
     Получает заказ
     - Parameters:
        - completion: Замыкание, которое вызывается при завершении запроса на получение заказа
            - Если запрос завершился успешно, возвращает отсортированный список ``NFT`` в корзине
            - Если запрос завершился неудачно, возвращает ошибку
     */
    func getOrder(_ completion: @escaping (Error) -> Void)

    /**
     Получает общую стоимость ``NFT`` в корзине
     - Returns: Общая стоимость ``NFT`` в корзине
     */
    func getNftsTotalValue() -> Float

    /**
     Удаляет ``NFT`` из корзины
     - Parameters:
        - id: ``NFT/id`` удаляемого ``NFT``
        - completion: Замыкание, которое вызывается при завершении удаления ``NFT`` из корзины
            - Если удаление прошло успешно, возвращает `nil`
            - Если удаление завершилось неудачно, возвращает ошибку
     */
    func removeNft(by id: String, _ completion: @escaping (Error?) -> Void)

    /// Очищает корзину c заказом
    func clearCart()

    /**
     Сортирует ``NFT`` в корзине
     - Parameter option: Тип ``SortOption`` сортировки
     */
    func sortBy(option: SortOption)
}

// MARK: - CartViewModel class

/**
``CartViewModel`` - это вью-модель корзины
 
Cодержит методы для работы с корзиной, такие как получение заказа, удаление ``NFT`` из корзины, очистка корзины и т.д.
*/
final class CartViewModel {

    // MARK: - Properties

    /// Наблюдаемое свойство списка ``NFT`` в корзине
    @Observable var nfts: [NFT]

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
     Сортирует ``NFT`` в соответствии с текущим типом и направлением сортировки
     
     По умолчанию, если не был ранее установлен тип и направление сортировки, она будет произведена по ``SortDirection/ascending`` и по ``SortOption/name`` ``NFT``
     - Parameter nfts: Список ``NFT``, который нужно отсортировать
     - Returns: Отсортированный список ``NFT``
     */
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
