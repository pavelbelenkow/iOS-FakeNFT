//
//  UserNFTsCollectionViewCell.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import UIKit

final class UserNFTsCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    weak var delegate: NFTCellDelegate?
    private let analyticsService = AnalyticsService()
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = UIColor.NFTColor.white
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()

    private lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = UIColor.NFTColor.white
        infoView.translatesAutoresizingMaskIntoConstraints = false
        return infoView
    }()

    private lazy var imageNFTImageView: UIImageView = {
        let imageNFTImageView = UIImageView()
        imageNFTImageView.layer.cornerRadius = 12
        imageNFTImageView.clipsToBounds = true
        imageNFTImageView.translatesAutoresizingMaskIntoConstraints = false
        return imageNFTImageView
    }()

    private lazy var likedButton: UIButton = {
        let likedButton = UIButton()
        likedButton.translatesAutoresizingMaskIntoConstraints = false
        likedButton.addTarget(
            self,
            action: #selector(didLikedButton),
            for: .touchUpInside
        )
        return likedButton
    }()

    private lazy var cartButton: UIButton = {
        let cartButton = UIButton()
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.addTarget(
            self,
            action: #selector(didCartButton),
            for: .touchUpInside
        )
        return cartButton
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.NFTFont.bold17
        nameLabel.textColor = UIColor.NFTColor.black
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.NFTFont.medium10
        priceLabel.textColor = UIColor.NFTColor.black
        priceLabel.textAlignment = .left
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
    }()

    private lazy var ratingImageView: UIImageView = {
        let ratingImageView = UIImageView()
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        return ratingImageView
    }()

    private var id = String()
    private var isLiked = false
    private var isAddToCart = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUserNFTsCollectionViewCell(
        with model: UserNFTsCollectionViewCellModel,
        delegate: NFTCellDelegate) {
        imageNFTImageView.loadImage(url: model.image)
        ratingImageView.image = setRatingStars(rating: model.rating)
        nameLabel.text = model.name
        priceLabel.text = String(format: "%.2f", model.price) + " ETH"
        id = model.id
        isLiked = model.isLiked
        isAddToCart = model.isAddToCart
        setLikeButtonImage()
        setCartButtonImage()
        self.delegate = delegate
    }

    private func addSubviews() {
        infoView.addSubview(cartButton)
        infoView.addSubview(nameLabel)
        infoView.addSubview(priceLabel)
        infoView.addSubview(ratingImageView)
        cardView.addSubview(imageNFTImageView)
        cardView.addSubview(infoView)
        cardView.addSubview(likedButton)
        contentView.addSubview(cardView)
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20
            )
        ])

        NSLayoutConstraint.activate([
            infoView.heightAnchor.constraint(equalToConstant: 56),
            infoView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            imageNFTImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageNFTImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageNFTImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            imageNFTImageView.bottomAnchor.constraint(
                equalTo: infoView.topAnchor,
                constant: -8
            )
        ])

        NSLayoutConstraint.activate([
            likedButton.heightAnchor.constraint(equalToConstant: 40),
            likedButton.widthAnchor.constraint(equalToConstant: 40),
            likedButton.topAnchor.constraint(equalTo: cardView.topAnchor),
            likedButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            cartButton.trailingAnchor.constraint(equalTo: infoView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: cartButton.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            priceLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),
            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            ratingImageView.topAnchor.constraint(equalTo: infoView.topAnchor),
            ratingImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor)
        ])
    }

    private func setRatingStars(rating: Int) -> UIImage? {
        switch rating {
        case 0: return UIImage.NFTIcon.zeroStars
        case 1: return UIImage.NFTIcon.oneStar
        case 2: return UIImage.NFTIcon.twoStars
        case 3: return UIImage.NFTIcon.threeStars
        case 4: return UIImage.NFTIcon.fourStars
        case 5: return UIImage.NFTIcon.fiveStars
        default: return nil
        }
    }

    private func setLikeButtonImage() {
        let image = isLiked ? UIImage.NFTIcon.liked : UIImage.NFTIcon.notLiked
        likedButton.setImage(
            image,
            for: .normal
        )
    }

    private func setCartButtonImage() {
        let image = isAddToCart ? UIImage.NFTIcon.cartDelete : UIImage.NFTIcon.cartAdd
        cartButton.setImage(
            image,
            for: .normal
        )
    }

    @objc private func didCartButton() {
        analyticsService.report(
            screen: .screenStatistic,
            event: .click,
            param: .setAddDeleteCartNFTStatistic
        )
        isAddToCart.toggle()
        setCartButtonImage()
        delegate?.cartNFT(id: id) { result in
            switch result {
            case .success(()):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @objc private func didLikedButton() {
        analyticsService.report(
            screen: .screenStatistic,
            event: .click,
            param: .setLikeNotLikeNFTStatistic
        )
        isLiked.toggle()
        setLikeButtonImage()
        delegate?.addNFTToFavourites(id: id) { result in
            switch result {
            case .success(()):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
