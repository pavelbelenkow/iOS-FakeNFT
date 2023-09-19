import UIKit

final class NFTCollectionCell: UITableViewCell {

    static let reuseIdentifier = "nftCell"

    private enum Constants {
        static let nftImageSize: CGFloat = 108
        static let likeButtonSize: CGFloat = 42

        // vertical content inset
        // horizontal content inset
        static let vInset: CGFloat = 8
        static let hInset: CGFloat = 16

        static let priceWord = "Цена"
        static let byBord = "от "
    }

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.NFTIcon.notLiked, for: .normal)
        return button
    }()

    private lazy var infoStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.distribution = .fill
        stackview.spacing = 5
        stackview.axis = .vertical
        return stackview
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = UIColor.NFTColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var starsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var authorStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()

    private lazy var byWordLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.text = Constants.byBord
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.NFTColor.black
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.NFTColor.black
        return label
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var priceWordLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = Constants.priceWord
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceCashLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    func configCell(nft: NFTModel, author: String, isLiked: Bool) {
        nameLabel.text = nft.name
        authorLabel.text = author
        priceCashLabel.text = "\(nft.price) ETH".replacingOccurrences(of: ".", with: ",")
        guard let image = nft.images.first else { return }
        nftImageView.loadImage(url: image.toURL, cornerRadius: 12)
        setupRating(nft.rating)
        let likedImage = isLiked ? UIImage.NFTIcon.liked : UIImage.NFTIcon.notLiked
        likeButton.setImage(likedImage, for: .normal)
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
    // MARK: - SetupView
    private func setupView() {
        contentView.backgroundColor = .NFTColor.white

        contentView.addSubview(nftImageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(priceStackView)
        contentView.addSubview(authorStackView)
        nftImageView.addSubview(likeButton)

        let infoViews = [nameLabel, starsImageView, authorStackView]
        let priceViews = [priceWordLabel, priceCashLabel]
        let authorViews = [byWordLabel, authorLabel]

        authorViews.forEach { authorStackView.addArrangedSubview($0)}
        infoViews.forEach { infoStackView.addArrangedSubview($0)}
        priceViews.forEach { priceStackView.addArrangedSubview($0)}
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.nftImageSize),
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.nftImageSize),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.hInset),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.vInset),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.vInset),

            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),

            infoStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            priceStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -Constants.hInset-40)
        ])
    }
}
