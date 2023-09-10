import UIKit

final class FavoritesCell: UICollectionViewCell {
    static let reuseIdentifier = "favoriteCell"

    private enum Constants {
        static let likeButtonSize: CGFloat = 42
        static let imageSize: CGFloat = 80
    }

    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.NFTIcon.notLiked, for: .normal)
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.text = "12312"
        return label
    }()

    private lazy var starsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ZeroStars")
        return imageView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .caption1
        label.text = "12312"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let imageViews = [nftImageView, likeButton]
        let infoViews = [nameLabel, starsImageView, priceLabel]

        contentView.addSubview(nftImageView)
        nftImageView.addSubview(likeButton)
        imageViews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        contentView.addSubview(infoStack)
        infoViews.forEach { infoStack.addArrangedSubview($0) }
        infoViews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),

            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonSize),

            infoStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            infoStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
