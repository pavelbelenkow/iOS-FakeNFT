//
//  NFTScreenCell.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit
import Kingfisher

final class NFTScreenCell: UICollectionViewCell {
    //MARK: Static Properties
    static let identifier = "NFTScreenCell"

    //MARK: Private Properties
    private var NFTImageView: UIImageView = {
        let view = UIImageView()

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

    private var ratingImage: UIImageView = {
        let view = UIImageView()

        return view
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(
            name: "SF Pro Text Bold",
            size: 17
        )
        label.textColor = UIColor.NFTColor.black

        return label
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()

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

    private let placeholder = ImagesPlaceholder()

    //MARK: Internal Properties
    var model: NFTModel? {
        didSet {
            guard let model else { return }

            setRatingImage(rating: model.rating)
            nameLabel.text = model.name
            priceLabel.text = "\(model.price) ETH"

            guard let encodedUrlString = model
                .images[0]
                .addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                ),
                  let url = URL(
                    string: encodedUrlString
            ) else {
                print("Invalid URL:", model.images[0])
                return
            }

            NFTImageView.kf.setImage(with: url, placeholder: placeholder)
        }
    }

    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCell()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //MARK: Overriden Methods
    override func prepareForReuse() {
        super.prepareForReuse()

        NFTImageView.kf.cancelDownloadTask()
        NFTImageView.image = nil
        ratingImage.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
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
            ),
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
            )
        ])
    }

    private func setRatingImage(rating: Int) {
        var imageName = String()

        switch rating {
        case 0:
            imageName = "ZeroStars"
        case 1:
            imageName = "OneStar"
        case 2:
            imageName = "TwoStars"
        case 3:
            imageName = "ThreeStars"
        case 4:
            imageName = "FourStars"
        default:
            imageName = "FiveStars"
        }

        ratingImage.image = UIImage(named: imageName)
    }
}
