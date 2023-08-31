//
//  UserNFTsCollectionViewCellModel.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import UIKit
//Структура для заполнения ячеек коллекции юзера
struct UserNFTsCollectionViewCellModel {
    let name: String    //имя NFT
    let image: URL //url адрес изображения NFT
    let rating: Int  //рейтинг NFT
    let price: Double  //цена NFT
    let id: String  //id NFT
}
