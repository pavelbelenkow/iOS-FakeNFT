import UIKit

private enum Constants {
    static let radius: CGFloat = 12
    static let nftImageHeight: CGFloat = 108
    static let ratingImageWidth: CGFloat = 68
}

final class CartCell: UITableViewCell {
    
    static let reuseIdentifier = "cart"
    
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.radius
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
        label.text = "Цена"
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
}

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
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.nftImageHeight),
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.nftImageHeight),
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
            nftRatingImageView.heightAnchor.constraint(equalToConstant: Constants.radius),
            nftRatingImageView.widthAnchor.constraint(equalToConstant: Constants.ratingImageWidth),
            nftRatingImageView.topAnchor.constraint(equalTo: nftTitleLabel.bottomAnchor, constant: 4),
            nftRatingImageView.leadingAnchor.constraint(equalTo: nftTitleLabel.leadingAnchor)
        ])
    }
    
    func addPriceTitleLabel() {
        detailNftView.addSubview(priceTitleLabel)
        
        NSLayoutConstraint.activate([
            priceTitleLabel.topAnchor.constraint(equalTo: nftRatingImageView.bottomAnchor, constant: Constants.radius),
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

private extension CartCell {
    
    @objc func removeNftFromCart() {
        // TODO: add impl of removing nft
    }
}

extension CartCell {
    
    func configure() {
        backgroundColor = .clear
        addSubviews()
        
        nftImageView.image = UIImage(named: "AppIcon")
        nftTitleLabel.text = "April"
        nftRatingImageView.image = UIImage.NFTIcon.threeStars
        nftPriceLabel.text = "1,78 ETH"
    }
}
