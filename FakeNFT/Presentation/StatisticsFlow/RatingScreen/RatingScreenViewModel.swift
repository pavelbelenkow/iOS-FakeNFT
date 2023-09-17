//
//  RatingScreenViewModel.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import Foundation

final class RatingScreenViewModel {
    private let client = DefaultNetworkClient()
    private let request = ListUsersRequest()
    private let sortingOrderStorage = SortingOrderStorage()

    @Observable
    private(set) var listUsers: [User] = []

    @Observable
    private(set) var isLoading: Bool = false

    func getListUsers() {
        isLoading = true
        client.send(
            request: request,
            type: [User].self
        ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let listUsers):
                    self.listUsers = self.sortedAccordingSortingOrder(list: listUsers)
                case .failure(let error):
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
        return RatingTableViewCellModel(
            indexRow: Int(),
            avatar: URL(fileURLWithPath: String()),
            name: String(),
            rating: String()
        )
    }

    func sortedByRatingAlert() {
        listUsers = sortedByRating(list: listUsers)
        sortingOrderStorage.isRatingOrder = true
    }

    func sortedByNameAlert() {
        listUsers = sortedByName(list: listUsers)
        sortingOrderStorage.isRatingOrder = false
    }

    private func sortedAccordingSortingOrder(list: [User]) -> [User] {
        return sortingOrderStorage.isRatingOrder ? sortedByRating(list: list) : sortedByName(list: list)
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
