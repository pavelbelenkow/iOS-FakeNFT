//
//  SortedAlert.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import UIKit

final class SortedAlert {
    func callAlert(nameAction: @escaping () -> (), ratingAction: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(
            title: "",
            message: "Сортировка",
            preferredStyle: .actionSheet)
        
        let nameAction = UIAlertAction(
            title: "По имени",
            style: .default
        ) { _ in
            nameAction()
        }
        
        let ratingAction = UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { _ in
            ratingAction()
        }
        
        let cancelAction = UIAlertAction(
            title: "Закрыть",
            style: .cancel
        ) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(nameAction)
        alert.addAction(ratingAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
