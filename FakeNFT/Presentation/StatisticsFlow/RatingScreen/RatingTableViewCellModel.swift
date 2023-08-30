//
//  RatingTableViewCellModel.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import UIKit
//Структура для заполнения ячеек таблицы ретинга юзера
struct RatingTableViewCellModel {
    let indexRow: Int   //порядковый номер юзера в таблице
    let avatar: URL //url адрес аватара юзера
    let name: String    //имя юзера
    let rating: String  //рейтинг юзера
}
