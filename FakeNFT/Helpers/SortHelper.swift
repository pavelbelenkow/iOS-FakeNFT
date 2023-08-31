import Foundation

enum SortOption {
    case price
    case rating
    case name
    
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

enum SortDirection {
    case ascending
    case descending
}
