//
//  NavBarBackButton.swift
//  FakeNFT
//
//  Created by D on 10.09.2023.
//

import UIKit

final class NavBarBackButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(named: "ChevronLeft"), for: .normal)
        tintColor = UIColor.NFTColor.black
        let width: CGFloat = 42
        self.frame.size = CGSize(width: width, height: width)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
