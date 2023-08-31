//
//  UserNFTsCollectionViewCell.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import UIKit

final class UserNFTsCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
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
    
    private lazy var likedImageView: UIImageView = {
        let likedImageView = UIImageView()
        likedImageView.translatesAutoresizingMaskIntoConstraints = false
        return likedImageView
    }()
    
    private lazy var cartButton: UIButton = {
        let cartButton = UIButton()
        cartButton.setImage(
            UIImage.NFTIcon.cartAdd,
            for: .normal
        )
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    func configureUserNFTsCollectionViewCell(with model: UserNFTsCollectionViewCellModel) {
        self.imageNFTImageView.loadImage(url: model.image)
        self.ratingImageView.image = setRatingStars(rating: model.rating)
        self.nameLabel.text = model.name
        self.priceLabel.text = String(format: "%.2f", model.price) + " ETH"
        self.id = model.id
        self.likedImageView.image = UIImage.NFTIcon.notLiked
    }
    
    private func addSubviews() {
        infoView.addSubview(cartButton)
        infoView.addSubview(nameLabel)
        infoView.addSubview(priceLabel)
        infoView.addSubview(ratingImageView)
        cardView.addSubview(imageNFTImageView)
        cardView.addSubview(infoView)
        cardView.addSubview(likedImageView)
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
            likedImageView.heightAnchor.constraint(equalToConstant: 40),
            likedImageView.widthAnchor.constraint(equalToConstant: 40),
            likedImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            likedImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
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
    
    private func setRatingStars(rating: Int) -> UIImage {
        switch rating {
        case 1: return UIImage.NFTIcon.oneStar
        case 2: return UIImage.NFTIcon.twoStars
        case 3: return UIImage.NFTIcon.threeStars
        case 4: return UIImage.NFTIcon.fourStars
        case 5: return UIImage.NFTIcon.fiveStars
        default: return UIImage()
        }
    }
    
    @objc private func didCartButton() {
        print(id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


