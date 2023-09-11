import Foundation
import ProgressHUD

protocol FavoritesViewModelFetchingProtocol {
    func loadNFT(by id: Int)
    func loadUsersNFT()
}

final class FavoritesViewModel {
    private let nftNetworkService = NFTNetworkService()

    @Observable
    private(set) var nfts = [NFTModel]()

    private let group = DispatchGroup()

    var nftIds = [Int]()

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
                    self.nfts.append(nft)
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
