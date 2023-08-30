//
//  CatalogueCell.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

final class CatalogueCell: UITableViewCell {
    //MARK: Static Properties
    static let identifier = "CatalogueCell"

    //MARK: Private Properties
    private let collectionImageView: UIImageView = {
        let view = UIImageView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12

        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .black
        label.text = "Peach (10)"
        label.font = UIFont(
            name: "SF Pro Text Bold",
            size: 17
        )

        return label
    }()

    //MARK: Initialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: Overrides Methods
    override func prepareForReuse() {
        //TODO: Чистить информацию ячейки
        collectionImageView.backgroundColor = .clear
        super.prepareForReuse()
    }

    //MARK: Private Methods
    private func makeCell() {
        setBackgroundColor()
        addSubviews()
        applyConstraints()
    }

    private func setBackgroundColor() {
        contentView.backgroundColor = UIColor.NFTColor.white
    }

    private func addSubviews() {
        [collectionImageView, nameLabel].forEach { item in
            contentView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(
                equalToConstant: 179
            ),
            collectionImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            collectionImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            collectionImageView.bottomAnchor.constraint(
                equalTo: nameLabel.topAnchor,
                constant: -4
            ),
            collectionImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: collectionImageView.leadingAnchor
            ),
            nameLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -13
            )
        ])
    }

    //MARK: Internal Methods
    func configCell() {
        //TODO: Тянуть изображения из сети
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0

        collectionImageView.backgroundColor = UIColor(
            red: red, green: green, blue: blue, alpha: 1.0
        )
    }
}
