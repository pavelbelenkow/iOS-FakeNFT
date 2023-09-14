//
//  NFTScreenView.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

final class NFTScreenView: UIView {
    //MARK: Private Properties
    private var coverImage: UIImageView = {
        let view = UIImageView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private var headerLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(
            name: "SF Pro Text Bold",
            size: 22
        )
        label.textColor = UIColor.NFTColor.black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(
            name: "SF Pro Text Regular",
            size: 13
        )
        label.textColor = UIColor.NFTColor.black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(
            name: "SF Pro Text Regular",
            size: 13
        )
        label.numberOfLines = 4
        label.textColor = UIColor.NFTColor.black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let layout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        return flowLayout
    }()

    private let authorLink: UITextView = {
        let textView = UITextView()

        textView.isEditable = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = [.link]
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(
            NFTScreenCell.self, forCellWithReuseIdentifier: NFTScreenCell.identifier
        )
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let placeholder = ImagesPlaceholder()

    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    convenience init(
        dataSource: UICollectionViewDataSource,
        collectionViewDelegate: UICollectionViewDelegateFlowLayout,
        textViewDelegate: UITextViewDelegate
    ) {
        self.init()
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = dataSource
        authorLink.delegate = textViewDelegate
    }

    //MARK: Private Methods
    private func makeView() {
        setBackgroundColor()
        addSubviews()
        applyConstraints()
    }

    private func setBackgroundColor() {
        backgroundColor = UIColor.NFTColor.white
    }

    private func addSubviews() {
        [
            coverImage,
            headerLabel,
            authorLabel,
            descriptionLabel,
            collectionView,
            authorLink
        ].forEach { item in
            addSubview(item)
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(
                equalTo: topAnchor
            ),
            coverImage.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            coverImage.heightAnchor.constraint(
                equalToConstant: 310
            ),
            coverImage.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            headerLabel.topAnchor.constraint(
                equalTo: coverImage.bottomAnchor,
                constant: 16
            ),
            headerLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            authorLabel.topAnchor.constraint(
                equalTo: headerLabel.bottomAnchor,
                constant: 13
            ),
            authorLabel.leadingAnchor.constraint(
                equalTo: headerLabel.leadingAnchor
            ),
            descriptionLabel.topAnchor.constraint(
                equalTo: authorLabel.bottomAnchor,
                constant: 5
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: authorLabel.leadingAnchor
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            collectionView.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: 16
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            authorLink.bottomAnchor.constraint(
                equalTo: authorLabel.bottomAnchor,
                constant: -2
            ),
            authorLink.leadingAnchor.constraint(
                equalTo: authorLabel.trailingAnchor,
                constant: 1
            ),
            authorLink.heightAnchor.constraint(
                equalToConstant: 23
            ),
            authorLink.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            )
        ])
    }

    private func setAuthorLinkName(with name: String) {
        let attributedString = NSMutableAttributedString(string: "")
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .link: URL(string: "https://example.com")!,
            .foregroundColor: UIColor.red,
            .font: UIFont(
                name: "SF Pro Text Regular",
                size: 15
            )
        ]
        let linkString = NSAttributedString(string: name, attributes: linkAttributes)
        attributedString.append(linkString)
        authorLink.attributedText = attributedString
    }

    private func setCoverImage(with url: String) {
        guard let encodedUrlString = url
            .addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
              let url = URL(
                string: encodedUrlString
        ) else {
            assertionFailure("Invalid URL: \(url)")
            return
        }
        coverImage.kf.setImage(with: url, placeholder: placeholder)
    }

    //MARK: Internal Methods
    func updateCollectionView() {
        collectionView.reloadData()
    }

    func configView(with model: CatalogueCellModel?) {
        guard let model else { return }

        setCoverImage(with: model.url)
        headerLabel.text = model.name
        descriptionLabel.text = model.description
        setAuthorLinkName(with: model.author)
        authorLabel.text = "Автор коллекции:"
    }

    func showErrorView() {
        let label: UILabel = {
            let label = UILabel()
            label.text = "Не удалось загрузить NFT"
            label.font = UIFont(
                name: "SF Pro Text Bold",
                size: 17
            )
            label.textColor = UIColor.NFTColor.black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        collectionView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(
                equalTo: collectionView.centerYAnchor
            ),
            label.centerXAnchor.constraint(
                equalTo: collectionView.centerXAnchor
            )
        ])
    }

    func showErrorAuthorName() {
        let label: UILabel = {
            let label = UILabel()
            label.text = "Не удалось загрузить информацию об авторе"
            label.font = UIFont(
                name: "SF Pro Text Bold",
                size: 17
            )
            label.textColor = UIColor.NFTColor.black
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 2
            label.textAlignment = .center
            return label
        }()

        coverImage.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(
                equalTo: coverImage.centerYAnchor
            ),
            label.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            label.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            )
        ])
    }
}
