//
//  TitleAndTextFieldStackView.swift
//  FakeNFT
//
//  Created by D on 31.08.2023.
//

import UIKit

final class TitleAndTextFieldStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fill
        spacing = 8
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
