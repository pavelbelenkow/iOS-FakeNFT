//
//  User.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import Foundation

struct User: Codable {
    /// Имя юзера
    let name: String
    /// Адрес аватара юзера
    let avatar: String
    /// Описание юзера
    let description: String
    /// Адрес веб-сайта юзера
    let website: String
    /// Список NFT юзера
    let nfts: [String]
    /// Рейтинг юзера
    let rating: String
    /// Id юзера
    let id: String
}
