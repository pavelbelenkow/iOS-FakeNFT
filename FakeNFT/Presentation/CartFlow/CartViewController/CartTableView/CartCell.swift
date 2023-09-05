import UIKit

// MARK: - Protocols

protocol CartCellDelegate: AnyObject {
    func cartCellDidTapRemoveButton(by nft: NFT)
}

// MARK: - CartCell class

final class CartCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = Constants.Cart.cartReuseIdentifier
    
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.Cart.radius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var detailNftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Cart.priceText
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular13
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var removeNftButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.NFTColor.black
        button.setImage(UIImage.NFTIcon.cartDelete, for: .normal)
        button.addTarget(
            self,
            action: #selector(removeNftFromCart),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var nft: NFT?
    weak var delegate: CartCellDelegate?
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.image = nil
        nftTitleLabel.text = nil
        nftPriceLabel.text = nil
    }
}

// MARK: - Add Subviews

private extension CartCell {
    
    func addSubviews() {
        addNftImageView()
        addDetailNftView()
        addNftTitleLabel()
        addRatingStackView()
        addPriceTitleLabel()
        addNftPriceLabel()
        addRemoveNftButton()
    }
    
    func addNftImageView() {
        contentView.addSubview(nftImageView)
        
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.Cart.nftImageHeight),
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.Cart.nftImageHeight),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    func addDetailNftView() {
        contentView.addSubview(detailNftView)
        
        NSLayoutConstraint.activate([
            detailNftView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8),
            detailNftView.bottomAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: -8),
            detailNftView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20)
        ])
    }
    
    func addNftTitleLabel() {
        detailNftView.addSubview(nftTitleLabel)
        
        NSLayoutConstraint.activate([
            nftTitleLabel.topAnchor.constraint(equalTo: detailNftView.topAnchor),
            nftTitleLabel.leadingAnchor.constraint(equalTo: detailNftView.leadingAnchor)
        ])
    }
    
    func addRatingStackView() {
        detailNftView.addSubview(ratingStackView)

        NSLayoutConstraint.activate([
            ratingStackView.topAnchor.constraint(equalTo: nftTitleLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: nftTitleLabel.leadingAnchor)
        ])
    }
    
    func addPriceTitleLabel() {
        detailNftView.addSubview(priceTitleLabel)
        
        NSLayoutConstraint.activate([
            priceTitleLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: Constants.Cart.radius),
            priceTitleLabel.leadingAnchor.constraint(equalTo: nftTitleLabel.leadingAnchor)
        ])
    }
    
    func addNftPriceLabel() {
        detailNftView.addSubview(nftPriceLabel)
        
        NSLayoutConstraint.activate([
            nftPriceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftTitleLabel.leadingAnchor)
        ])
    }
    
    func addRemoveNftButton() {
        contentView.addSubview(removeNftButton)
        
        NSLayoutConstraint.activate([
            removeNftButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeNftButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Private methods

private extension CartCell {
    
    func setImage(from image: String) {
        let imageURL = URL(string: image)
        NFTImageCache.loadAndCacheImage(for: nftImageView, with: imageURL)
    }
    
    func setRating(from rating: Int) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for i in 0 ..< 5 {
            let starImageView = UIImageView()
            starImageView.image = (i < rating) ? UIImage.NFTIcon.starActive : UIImage.NFTIcon.starNoActive
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
    
    func formatPrice(_ price: Float) -> String {
        let priceString = NumberFormatter
            .currencyFormatter
            .string(from: price as NSNumber) ?? ""
        return priceString + " " + Constants.Cart.currency
    }
    
    @objc func removeNftFromCart() {
        guard let nft else { return }
        delegate?.cartCellDidTapRemoveButton(by: nft)
    }
}

// MARK: - Methods

extension CartCell {
    
    func configure(from nft: NFT) {
        backgroundColor = .clear
        addSubviews()
        
        self.nft = nft
        
        nftTitleLabel.text = nft.name
        nftPriceLabel.text = formatPrice(nft.price)
        
        setImage(from: nft.image)
        setRating(from: nft.rating)
    }
}
