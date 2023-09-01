import UIKit
import Kingfisher

// MARK: - Protocols

protocol CartCellDelegate: AnyObject {
    func cartCellDidTapRemoveButton(by nft: NFT)
}

// MARK: - CartCell class

final class CartCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = Constants.Cart.reuseIdentifier
    
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
    
    private lazy var nftRatingImageView: UIImageView = {
        let view = UIImageView()
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
        nftRatingImageView.image = nil
        nftPriceLabel.text = nil
    }
}

// MARK: - Add Subviews

private extension CartCell {
    
    func addSubviews() {
        addNftImageView()
        addDetailNftView()
        addNftTitleLabel()
        addNftRatingImageView()
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
    
    func addNftRatingImageView() {
        detailNftView.addSubview(nftRatingImageView)
        
        NSLayoutConstraint.activate([
            nftRatingImageView.heightAnchor.constraint(equalToConstant: Constants.Cart.radius),
            nftRatingImageView.widthAnchor.constraint(equalToConstant: Constants.Cart.ratingImageWidth),
            nftRatingImageView.topAnchor.constraint(equalTo: nftTitleLabel.bottomAnchor, constant: 4),
            nftRatingImageView.leadingAnchor.constraint(equalTo: nftTitleLabel.leadingAnchor)
        ])
    }
    
    func addPriceTitleLabel() {
        detailNftView.addSubview(priceTitleLabel)
        
        NSLayoutConstraint.activate([
            priceTitleLabel.topAnchor.constraint(equalTo: nftRatingImageView.bottomAnchor, constant: Constants.Cart.radius),
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
    
    func setRating(from rating: Int) -> UIImage {
        switch rating {
        case 0: return UIImage.NFTIcon.zeroStars
        case 1: return UIImage.NFTIcon.oneStar
        case 2: return UIImage.NFTIcon.twoStars
        case 3: return UIImage.NFTIcon.threeStars
        case 4: return UIImage.NFTIcon.fourStars
        case 5: return UIImage.NFTIcon.fiveStars
        default: return UIImage()
        }
    }
    
    func formatPrice(_ price: Float) -> String {
        let valueString = NumberFormatter
            .currencyFormatter
            .string(from: price as NSNumber) ?? ""
        return valueString + " " + Constants.Cart.currency
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
        
        nftImageView.kf.setImage(with: URL(string: nft.image))
        nftTitleLabel.text = nft.name
        nftRatingImageView.image = setRating(from: nft.rating)
        nftPriceLabel.text = formatPrice(nft.price)
    }
}
