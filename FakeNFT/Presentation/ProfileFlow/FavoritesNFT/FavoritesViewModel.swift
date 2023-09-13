import Foundation
import ProgressHUD

protocol FavoritesViewModelFetchingProtocol {
    func loadNFT(by id: Int)
    func loadUsersNFT()
}

final class FavoritesViewModel {
    private let nftNetworkService = NFTNetworkService()
    private let likesNetworkService = LikesEditedNetworkService()

    @Observable
    private(set) var nfts = [String: NFTModel]()

    private let group = DispatchGroup()

    var nftIds = [Int]()

    func deleteFromFavorites(by id: String) {
        ProgressHUD.show()
        nftIds = nftIds.filter { String($0) != id }
        let likes = nftIds.compactMap { String($0) }
        let likesEdited = LikesEdited(likes: likes)
        likesNetworkService.sendEdited(
            likes: likesEdited
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.nfts.removeValue(forKey: id)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
        ProgressHUD.dismiss()
    }

}

extension FavoritesViewModel: FavoritesViewModelFetchingProtocol {
    func loadNFT(by id: Int) {
        group.enter()
        nftNetworkService.getNFT(id: id) { [weak self] result in
            guard let self else { return }
            defer {
                self.group.leave()
            }
            DispatchQueue.main.async {
                switch result {
                case let .success(nft):
                    self.nfts[nft.id] = nft
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func loadUsersNFT() {
        ProgressHUD.show()
        nftIds.forEach { id in
            self.loadNFT(by: id)
        }
        ProgressHUD.dismiss()
    }
}
