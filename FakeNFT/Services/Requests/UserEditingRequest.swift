//
//  ChangedUserRequest.swift
//  FakeNFT
//
//  Created by D on 31.08.2023.
//

import Foundation

struct UserEditingRequest: NetworkRequest {

    let userToUpdate: UserEditing

    init(userToUpdate: UserEditing) {
        self.userToUpdate = userToUpdate
    }

    var endpoint: URL? {
        get {
            URL(string: self.baseEndpoint + "profile/1")
        }
    }

    var httpMethod: HttpMethod {
        get {
            .put
        }
    }

    var dto: Encodable? {
        get {
            userToUpdate
        }
    }
}
