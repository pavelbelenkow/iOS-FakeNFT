import UIKit

final class NFTCollectionCell: UITableViewCell {

    static let reuseIdentifier = "nftCell"

    private enum Constants {
        static let nftImageSize: CGFloat = 108
        static let likeButtonSize: CGFloat = 42
        static let vInset: CGFloat = 8                  // vertical content inset
        static let hInset: CGFloat = 16                 // horizontal content inset
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
        button.setImage(UIImage(named: "NotLiked"), for: .normal)
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
        label.text = "priv"
        label.textColor = UIColor.NFTColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var starsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ZeroStars")
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
        label.text = "от"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.NFTColor.black
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "athsds"
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
        label.text = "Цена"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceCashLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.text = "1232191"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
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
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.hInset-40)
        ])
    }
}
