//
//  ErrorView.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 12.09.2023.
//

import UIKit

final class ErrorView: UIView {
    //MARK: Private Properties
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Нет интернета"
        label.font = UIFont.NFTFont.bold17
        label.textColor = UIColor.NFTColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //MARK: Private Properties
    private func makeView() {
        backgroundColor = UIColor.NFTColor.white
        addSubview()
        applyConstraints()
    }

    private func addSubview() {
        addSubview(label)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(
                equalTo: safeAreaLayoutGuide.centerXAnchor
            ),
            label.centerYAnchor.constraint(
                equalTo: safeAreaLayoutGuide.centerYAnchor
            )
        ])
    }
}
