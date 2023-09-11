//
//  RatingTableViewCellModel.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import UIKit

struct RatingTableViewCellModel {
    /// Порядковый номер юзера в таблице
    let indexRow: Int
    /// URL адрес аватара юзера
    let avatar: URL
    /// Имя юзера
    let name: String
    /// Рейтинг юзера
    let rating: String
}
