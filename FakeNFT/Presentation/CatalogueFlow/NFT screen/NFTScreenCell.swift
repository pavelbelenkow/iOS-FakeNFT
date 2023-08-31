//
//  NFTScreenCell.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

final class NFTScreenCell: UICollectionViewCell {
    //MARK: Static Properties
    static let identifier = "NFTScreenCell"

    //MARK: Private Properties
    private let NFTImageView: UIImageView = {
        let view = UIImageView()

        view.backgroundColor = .gray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12

        return view
    }()

    private let likeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Liked")

        button.setImage(image, for: .normal)

        return button
    }()

    private let ratingImage: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "ThreeStars")

        view.image = image

        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.text = "Archie"
        label.font = UIFont(
            name: "SF Pro Text Bold",
            size: 17
        )
        label.textColor = UIColor.NFTColor.black

        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()

        label.text = "1 ETH"
        label.font = UIFont(
            name: "SF Pro Text Regular",
            size: 10
        )
        label.textColor = UIColor.NFTColor.black

        return label
    }()

    private let cartButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "CartAdd")

        button.setImage(image, for: .normal)

        return button
    }()

    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCell()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //MARK: Private Methods
    private func makeCell() {
        addSubviews()
        applyConstraints()
    }

    private func addSubviews() {
        [
            NFTImageView,
            ratingImage,
            nameLabel,
            priceLabel,
            cartButton
        ].forEach { item in
            contentView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        NFTImageView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            NFTImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            NFTImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            NFTImageView.bottomAnchor.constraint(
                equalTo: ratingImage.topAnchor,
                constant: -8
            ),
            NFTImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            cartButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            cartButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20
            ),
            cartButton.heightAnchor.constraint(
                equalToConstant: 40
            ),
            cartButton.heightAnchor.constraint(
                equalToConstant: 40
            ),
            priceLabel.bottomAnchor.constraint(
                equalTo: cartButton.bottomAnchor
            ),
            priceLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            nameLabel.bottomAnchor.constraint(
                equalTo: priceLabel.topAnchor,
                constant: -4
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: priceLabel.leadingAnchor
            ),
            ratingImage.bottomAnchor.constraint(
                equalTo: nameLabel.topAnchor,
                constant: -5
            ),
            ratingImage.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),
            likeButton.topAnchor.constraint(
                equalTo: NFTImageView.topAnchor
            ),
            likeButton.trailingAnchor.constraint(
                equalTo: NFTImageView.trailingAnchor
            ),
            likeButton.heightAnchor.constraint(
                equalToConstant: 42
            ),
            likeButton.widthAnchor.constraint(
                equalToConstant: 42
            )
        ])
    }
}
