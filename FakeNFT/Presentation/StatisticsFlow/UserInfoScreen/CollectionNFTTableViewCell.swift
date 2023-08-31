//
//  CollectionNFTTableViewCell.swift
//  FakeNFT
//
//  Created by REYNIKOV ANTON on 30.08.2023.
//

import UIKit

final class CollectionNFTTableViewCell: UITableViewCell, ReuseIdentifying {
    private lazy var itemsView: UIView = {
        let itemsView = UIView()
        itemsView.backgroundColor = UIColor.NFTColor.white
        itemsView.translatesAutoresizingMaskIntoConstraints = false
        return itemsView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Коллекция NFT"
        titleLabel.font = UIFont.NFTFont.bold17
        titleLabel.textColor = UIColor.NFTColor.black
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var countLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.NFTFont.bold17
        titleLabel.textColor = UIColor.NFTColor.black
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var chevronForwardImageView: UIImageView = {
        let chevronForwardImageView = UIImageView()
        chevronForwardImageView.image = UIImage.NFTIcon.chevronForward
        chevronForwardImageView.translatesAutoresizingMaskIntoConstraints = false
        return chevronForwardImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubviews()
        makeConstraints()
    }
    
    func configureCollectionNFTTableViewCell(countCollectionNFT: Int) {
        countLabel.text = "(\(countCollectionNFT))"
    }
    
    private func addSubviews() {
        itemsView.addSubview(titleLabel)
        itemsView.addSubview(countLabel)
        itemsView.addSubview(chevronForwardImageView)
        contentView.addSubview(itemsView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            itemsView.heightAnchor.constraint(equalToConstant: 22),
            itemsView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            itemsView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            itemsView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: itemsView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: itemsView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: 8
            ),
            countLabel.centerYAnchor.constraint(equalTo: itemsView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chevronForwardImageView.trailingAnchor.constraint(equalTo: itemsView.trailingAnchor),
            chevronForwardImageView.centerYAnchor.constraint(equalTo: itemsView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


