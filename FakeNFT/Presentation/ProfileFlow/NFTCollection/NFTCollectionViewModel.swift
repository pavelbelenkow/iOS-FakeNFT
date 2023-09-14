import Foundation
import ProgressHUD

enum SortingType: String {
    case byPrice = "По цене"
    case byRating = "По рейтингу"
    case byName = "По названию"
    case none
}

protocol NFTCollectionViewModelFetchingProtocol {
    func loadNFT(by id: Int)
    func loadAuthors(by id: Int)
    func loadUsersNFT()
}

private protocol NFTCollectionViewModelSortingProtocol {
    func sortByPrice()
    func sortByName()
    func sortByRating()
}

final class NFTCollectionViewModel {
    private let nftNetworkService = NFTNetworkService()
    private let authorInfoService = UserInfoNetworkService()

    private(set) var nfts = [NFTModel]()

    @Observable
    private(set) var authorsNames = [String]()

    @Observable
    private(set) var sortingType: SortingType = .none

    private let group = DispatchGroup()

    var ids = [Int]()

    func sort(by type: SortingType) {
        switch type {
        case .byPrice:
            sortByPrice()
        case .byRating:
            sortByRating()
        case .byName:
            sortByName()
        case .none:
            break
        }
    }
}

extension NFTCollectionViewModel: NFTCollectionViewModelFetchingProtocol {
    func loadNFT(by id: Int) {
        nftNetworkService.getNFT(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    self.loadAuthors(by: Int(nft.author) ?? 0)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func loadAuthors(by id: Int) {
        group.enter()
        authorInfoService.getProfile(by: id) { [weak self] result in
            guard let self else { return }
            defer {
                self.group.leave()
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.authorsNames.append(user.name)

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func loadUsersNFT() {
        ProgressHUD.show()
        ids.forEach { id in
            loadNFT(by: id)
        }
        ProgressHUD.dismiss()
    }
}

extension NFTCollectionViewModel: NFTCollectionViewModelSortingProtocol {
    func sortByPrice() {
        nfts.sort { $0.price > $1.price }
        sortingType = .byPrice
    }

    func sortByName() {
        nfts.sort { $0.name < $1.name }
        sortingType = .byName
    }

    func sortByRating() {
        nfts.sort { $0.rating > $1.rating}
        sortingType = .byRating
    }
}
