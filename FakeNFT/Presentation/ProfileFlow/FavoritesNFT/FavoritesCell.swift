import UIKit

protocol FavoritesCellDelegate: AnyObject {
    func likeButtonTapped(with nftID: String)
}

final class FavoritesCell: UICollectionViewCell {
    static let reuseIdentifier = "favoriteCell"

    weak var delegate: FavoritesCellDelegate?

    private var nftId: String?

    private enum Constants {
        static let likeButtonSize: CGFloat = 42
        static let imageSize: CGFloat = 80
    }

    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var likeButton: CustomLikeButton = {
        let button = CustomLikeButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.NFTIcon.liked, for: .normal)
        button.addTarget(
            self,
            action: #selector(likeButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textAlignment = .left
        label.numberOfLines = .zero
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

    func configCell(nft: NFTModel) {
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH".replacingOccurrences(of: ".", with: ",")
        setupRating(nft.rating)
        guard let image = nft.images.first else { return }
        nftImageView.loadImage(url: image.toURL, cornerRadius: 12)
        nftId = nft.id
    }

    @objc
    private func likeButtonTapped() {
        delegate?.likeButtonTapped(with: self.nftId ?? "")
    }

    private func setupRating(_ rating: Int) {
        switch rating {
        case 5:
            starsImageView.image = UIImage(named: "FiveStars")
        case 4:
            starsImageView.image = UIImage(named: "FourStars")
        case 3:
            starsImageView.image = UIImage(named: "ThreeStars")
        case 2:
            starsImageView.image = UIImage(named: "TwoStars")
        case 1:
            starsImageView.image = UIImage(named: "OneStar")
        default:
            starsImageView.image = UIImage(named: "ZeroStars")
        }
    }

    private func setupView() {
        let imageViews = [nftImageView, likeButton]
        let infoViews = [nameLabel, starsImageView, priceLabel]

        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
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

            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 4),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -4),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonSize),

            infoStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            infoStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoStack.widthAnchor.constraint(equalToConstant: 76)
        ])
    }
}
