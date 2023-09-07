//
//  NFT.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import Foundation

struct NFT: Codable {
    //Время создания NFT
    let createdAt: String
    //Имя NFT
    let name: String
    //Адреса изображения NFT
    let images: [String]
    //Рейтинг NFT
    let rating: Int
    //Описание NFT
    let description: String
    //Цена NFT
    let price: Double
    //Id автора NFT
    let author: String
    //Id NFT
    let id: String
}
