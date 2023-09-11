//
//  Profile.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 08.09.2023.
//

import Foundation

struct Profile: Codable {
    /// Имя профиля
    let name: String
    /// Адрес аватара профиля
    let avatar: String
    /// Описание профиля
    let description: String
    /// Адрес веб-сайта профиля
    let website: String
    /// Список NFT профиля
    let nfts: [String]
    /// Список лайкнутых NFT профиля
    let likes: [String]
    /// Id профиля
    let id: String
}
