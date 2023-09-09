import UIKit

// MARK: - CurrencyCell class

final class CurrencyCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = Constants.Cart.currencyReuseIdentifier
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currencyImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.NFTColor.blackUniversal
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Constants.Cart.radius / 2
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionCurrencyStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var currencyTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular13
        return label
    }()
    
    private lazy var currencyAbbreviationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.NFTColor.green
        label.font = UIFont.NFTFont.regular13
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 1 : 0
            layer.borderColor = isSelected ? UIColor.NFTColor.black.cgColor : nil
         }
    }
}

// MARK: - Add Subviews

private extension CurrencyCell {
    
    func addSubviews() {
        addContentStackView()
        addCurrencyImageView()
        addDescriptionCurrencyStackView()
    }
    
    func addContentStackView() {
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func addCurrencyImageView() {
        contentStackView.addArrangedSubview(currencyImageView)
        
        NSLayoutConstraint.activate([
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func addDescriptionCurrencyStackView() {
        contentStackView.addArrangedSubview(descriptionCurrencyStackView)
        
        descriptionCurrencyStackView.addArrangedSubview(currencyTitleLabel)
        descriptionCurrencyStackView.addArrangedSubview(currencyAbbreviationLabel)
    }
}

// MARK: - Private methods

private extension CurrencyCell {
    
    func setCurrencyImage(from image: String) {
        let imageURL = URL(string: image)
        NFTImageCache.loadAndCacheImage(for: currencyImageView, with: imageURL)
    }
}

// MARK: - Methods

extension CurrencyCell {
    
    func configure(from currency: Currency) {
        backgroundColor = UIColor.NFTColor.lightGray
        layer.cornerRadius = Constants.Cart.radius
        clipsToBounds = true
        
        currencyTitleLabel.text = currency.title
        currencyAbbreviationLabel.text = currency.name
        
        addSubviews()
        setCurrencyImage(from: currency.image)
    }
}
