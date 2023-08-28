//
//  RatingScreenViewModel.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import UIKit

final class RatingScreenViewModel {
    private let listUsersNetReqService = ListUsersNetworkRequestService()
    @Observable
    private(set) var listUsers: [User] = []
    
    func getListUsers() {
        listUsersNetReqService.getListUsers { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let listUsers):
                    self.listUsers = self.sortedByRating(list: listUsers)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setInfoRatingTableViewCell(indexRow: Int) -> RatingTableViewCellModel {
        if let url = URL(string: listUsers[indexRow].avatar) {
            return RatingTableViewCellModel(
                indexRow: indexRow,
                avatar: url,
                name: listUsers[indexRow].name,
                rating: listUsers[indexRow].rating)
        }
        return RatingTableViewCellModel(indexRow: Int(), avatar: URL(fileURLWithPath: String()), name: String(), rating: String())
    }
    
    private func sortedByRating(list: [User]) -> [User] {
        return list.sorted {
            $0.rating.toInt() > $1.rating.toInt()
        }
    }
    
    private func sortedByName(list: [User]) -> [User] {
        return list.sorted {
            $0.name.lowercased() < $1.name.lowercased()
        }
    }
}
