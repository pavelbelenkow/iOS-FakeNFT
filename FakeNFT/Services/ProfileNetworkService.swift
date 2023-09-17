//
//  UserInfoNetworkService.swift
//  FakeNFT
//
//  Created by D on 29.08.2023.
//

import Foundation

final class ProfileNetworkService {
    private let client = DefaultNetworkClient()

    func getProfile(by id: Int, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = ProfileRequest(id: id)
        client.send(request: request, type: Profile.self, onResponse: completion)
    }
}
