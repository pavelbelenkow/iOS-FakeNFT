//
//  RatingScreenViewModel.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import Foundation

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
