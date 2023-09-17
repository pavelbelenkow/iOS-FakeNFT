//
//  EditScreenCustomLabel.swift
//  FakeNFT
//
//  Created by D on 31.08.2023.
//

import UIKit

final class EditScreenCustomLabel: UILabel {

    init(frame: CGRect, string: String) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        font = .headline3
        textColor = UIColor.NFTColor.black
        text = string
        backgroundColor = .white

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
