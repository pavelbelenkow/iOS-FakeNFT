//
//  CatalogueCell.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit
import Kingfisher

final class CatalogueCell: UITableViewCell {
    //MARK: Static Properties
    static let identifier = "CatalogueCell"

    //MARK: Private Properties
    private var collectionImageView: UIImageView = {
        let view = UIImageView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true

        return view
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .black
        label.text = "Peach (10)"
        label.font = UIFont(
            name: "SF Pro Text Bold",
            size: 17
        )
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let placeholder = ImagesPlaceholder()

    //MARK: Internal Properties
    var model: CatalogueCellModel? {
        didSet {
            guard let model else { return }

            nameLabel.text = "\(model.name) (\(model.nfts.count))"

            guard let encodedUrlString = model
                .url
                .addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                ),
                  let url = URL(
                    string: encodedUrlString
            ) else {
                print("Invalid URL:", model.url)
                return
            }
            collectionImageView.kf.setImage(with: url, placeholder: placeholder)
        }
    }

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
}
