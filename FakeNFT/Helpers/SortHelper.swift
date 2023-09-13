import Foundation

// MARK: - SortOption enum

/// Типы сортировки
enum SortOption: String {
    case price
    case rating
    case name
    
    /**
     Сравнительная функция для сортировки
     - Parameter sortDirection: Направление сортировки
     - Returns: Функция, которая принимает два ``NFT`` и возвращает **true**, если первый элемент должен быть раньше в отсортированном массиве
     */
    func compareFunction(sortDirection: SortDirection) -> (NFT, NFT) -> Bool {
        switch self {
        case .price:
            return { nft1, nft2 in
                return (sortDirection == .descending) ? nft1.price > nft2.price : nft1.price < nft2.price
            }
        case .rating:
            return { nft1, nft2 in
                return (sortDirection == .descending) ? nft1.rating < nft2.rating : nft1.rating > nft2.rating
            }
        case .name:
            return { nft1, nft2 in
                return (sortDirection == .descending) ? nft1.name > nft2.name : nft1.name < nft2.name
            }
        }
    }
}

// MARK: - SortDirection enum

/// Направление сортировки
enum SortDirection: String {
    case ascending
    case descending
}
