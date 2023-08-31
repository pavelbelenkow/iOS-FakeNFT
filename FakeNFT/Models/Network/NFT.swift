//
//  NFT.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import Foundation
//Структура для раскодирования данных NFT
struct NFT: Codable {
    let createdAt: String   //время создания NFT
    let name: String    //имя NFT
    let images: [String]  //адреса изображения NFT
    let rating: Int  //рейтинг NFT
    let description: String //описание NFT
    let price: Double   //цена NFT
    let author: String  //id автора NFT
    let id: String  //id NFT
}
