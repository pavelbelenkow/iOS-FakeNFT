//
//  User.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import Foundation
//Структура для раскодирования данных с запроса списка юзеров https://{{host}}/api/v1/users
struct User: Codable {
    let name: String    //имя юзера
    let avatar: String  //адрес аватара юзера
    let description: String //описание юзера
    let website: String //адрес веб-сайта юзера
    let nfts: [String] //список NFT юзера
    let rating: String  //рейтинг юзера
    let id: String  //id юзера
}
