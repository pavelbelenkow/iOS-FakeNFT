//
//  NFTScreenCell.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit
import Kingfisher

final class NFTScreenCell: UICollectionViewCell {
    // MARK: Static Properties
    static let identifier = "NFTScreenCell"

    // MARK: Private Properties
    private var NFTImageView: UIImageView = {
        let view = UIImageView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.isUserInteractionEnabled = true

        return view
    }()

    private var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(likeButtonTap), for: .touchUpInside)
        return button
    }()

    private var cartButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(cartButtonTap), for: .touchUpInside)
        return button
    }()

    private var ratingImage = UIImageView()
    private let placeholder = ImagesPlaceholder()
    private var nftID = String()

    private var nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.NFTFont.bold17
        label.textColor = UIColor.NFTColor.black

        return label
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.NFTFont.medium10
        label.textColor = UIColor.NFTColor.black

        return label
    }()

    // MARK: Internal Properties
    weak var delegate: NFTCellDelegate?

    // MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCell()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: Overriden Methods
    override func prepareForReuse() {
        super.prepareForReuse()

        NFTImageView.kf.cancelDownloadTask()
        NFTImageView.image = nil
        ratingImage.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }

    // MARK: Internal Methods
    func configCell(with model: NFTModel?, delegate: NFTCellDelegate) {
        guard let model else { return }

        setRatingImage(rating: model.rating)
        nameLabel.text = model.name
        priceLabel.text = "\(model.price) ETH"
        setLikeImage(isLiked: model.isLiked)
        setOrderImage(isOrdered: model.isOrdered)
        nftID = model.id

        guard let encodedUrlString = model
            .images[0]
            .addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
              let url = URL(
                string: encodedUrlString
        ) else {
            assertionFailure("Invalid URL: \(model.images[0])")
            return
        }

        NFTImageView.kf.setImage(with: url, placeholder: placeholder)

        self.delegate = delegate
    }
}

// MARK: Private Extension
private extension NFTScreenCell {
    @objc
    func likeButtonTap() {
        delegate?.addNFTToFavourites(id: nftID) { result in
            switch result {
            case .success(()):
                self.likeButton.layer.removeAllAnimations()
            case .failure:
                self.likeButton.layer.removeAllAnimations()
                self.showError(button: self.likeButton)
            }
        }
        animateButton(likeButton)
    }

    @objc
    func cartButtonTap() {
        delegate?.cartNFT(id: nftID) { result in
            switch result {
            case .success(()):
                self.cartButton.layer.removeAllAnimations()
            case .failure:
                self.cartButton.layer.removeAllAnimations()
                self.showError(button: self.cartButton)
            }
        }
        animateButton(cartButton)
    }

    func makeCell() {
        addSubviews()
        applyConstraints()
    }

    func addSubviews() {
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

    func applyConstraints() {
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
            cartButton.widthAnchor.constraint(
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
            nameLabel.trailingAnchor.constraint(
                equalTo: cartButton.leadingAnchor
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

    func setRatingImage(rating: Int) {
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

    func setLikeImage(isLiked: Bool?) {
        var likeImageName = String()

        if let isLiked, isLiked {
            likeImageName = "Liked"
        } else {
            likeImageName = "NotLiked"
        }

        likeButton.setImage(UIImage(named: likeImageName), for: .normal)
    }

    func setOrderImage(isOrdered: Bool?) {
        var orderImageName = String()

        if let isOrdered, isOrdered {
            orderImageName = "CartDelete"
        } else {
            orderImageName = "CartAdd"
        }

        cartButton.setImage(UIImage(named: orderImageName), for: .normal)
    }

    func animateButton(_ button: UIButton) {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [.repeat]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                button.transform = .identity
            }
        }
    }

    func showError(button: UIButton) {
        let originalPosition = button.center

        let leftPosition = CGPoint(x: originalPosition.x - 10, y: originalPosition.y)
        let rightPosition = CGPoint(x: originalPosition.x + 10, y: originalPosition.y)

        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3) {
                button.center = leftPosition
            }
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                button.center = rightPosition
            }
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                button.center = originalPosition
            }
        }, completion: nil)
    }

}
