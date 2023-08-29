//
//  UserInfoNetworkService.swift
//  FakeNFT
//
//  Created by D on 29.08.2023.
//

import Foundation

 final class UserInfoNetworkService {
     private let client = DefaultNetworkClient()
     private let request = UserInfoRequest()

     func getUserInfo(completion: @escaping (Result<UserInfo, Error>) -> Void) {
         client.send(request: request, type: UserInfo.self, onResponse: completion)
     }
 }
