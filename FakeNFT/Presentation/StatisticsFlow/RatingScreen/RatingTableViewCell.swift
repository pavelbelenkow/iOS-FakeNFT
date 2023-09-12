//
//  RatingTableViewCell.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import UIKit

final class RatingTableViewCell: UITableViewCell, ReuseIdentifying {
    private lazy var numberView: UIView = {
        let numberView = UIView()
        numberView.backgroundColor = UIColor.NFTColor.white
        numberView.translatesAutoresizingMaskIntoConstraints = false
        return numberView
    }()
    
    private lazy var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.font = UIFont.NFTFont.regular15
        numberLabel.textColor = UIColor.NFTColor.black
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberLabel
    }()
    
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.layer.cornerRadius = 12
        cardView.clipsToBounds = true
        cardView.backgroundColor = UIColor.NFTColor.lightGray
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 14
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.NFTFont.bold22
        nameLabel.textColor = UIColor.NFTColor.black
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var numberRatingLabel: UILabel = {
        let numberRatingLabel = UILabel()
        numberRatingLabel.font = UIFont.NFTFont.bold22
        numberRatingLabel.textColor = UIColor.NFTColor.black
        numberRatingLabel.textAlignment = .right
        numberRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberRatingLabel
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        selectionStyle = .none
        contentView.backgroundColor = UIColor.NFTColor.white
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureRatingTableViewCell(with model: RatingTableViewCellModel) {
        numberLabel.text = String(model.indexRow + 1)
        avatarImageView.loadImage(url: model.avatar)
        nameLabel.text = model.name
        numberRatingLabel.text = model.rating
    }
    
    private func addSubviews() {
        numberView.addSubview(numberLabel)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(numberRatingLabel)
        contentView.addSubview(numberView)
        contentView.addSubview(cardView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            numberView.heightAnchor.constraint(equalToConstant: 20),
            numberView.widthAnchor.constraint(equalToConstant: 27),
            numberView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: numberView.centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: numberView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 4
            ),
            cardView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 35
            ),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -4
            )
        ])
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 16
            )
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: 186),
            nameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 8
            )
        ])
        
        NSLayoutConstraint.activate([
            numberRatingLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            numberRatingLabel.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -16)
        ])
    }
}
