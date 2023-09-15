import UIKit

// MARK: - Protocols

/// Протокол ``CartCellDelegate`` определяет методы для удаления ``NFT`` из корзины
protocol CartCellDelegate: AnyObject {

    /**
     Метод, который обрабатывает нажатие на кнопку удаления ``NFT`` из корзины
     - Parameter nft: ``NFT``, который необходимо удалить
     */
    func cartCellDidTapRemoveButton(by nft: NFT)
}

// MARK: - CartCell class

/**
 Класс ``CartCell`` предоставляет методы для настройки ячейки корзины в ``CartTableView``
 
 Содержит набор представлений для отображения информации о ``NFT``
 */
final class CartCell: UITableViewCell {

    // MARK: - Properties

    /// Идентификатор ячейки корзины
    static let reuseIdentifier = Constants.Cart.cartReuseIdentifier

    /// Изображение ``NFT``
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.Cart.radius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Контейнер для детальной информации о ``NFT``
    private lazy var detailNftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Надпись о названии ``NFT``
    private lazy var nftTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Горизонтальный стек внутри контейнера для размещения рейтинга в звёздах
    private lazy var ratingStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Надпись о названии цены
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Cart.priceText
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular13
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Надпись о цене ``NFT``
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Кнопка удаления ``NFT`` из корзины
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

    /// ``NFT``, отображаемый в ячейке
    var nft: NFT?

    /// ``delegate`` ячейки корзины
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

    /**
     Загружает и кэширует изображение ``NFT`` с помощью ``NFTImageCache/loadAndCacheImage(for:with:)``, и устанавливает его в `nftImageView`
     - Parameter image: Ссылка на ``NFT/image``
     */
    func setImage(from image: String) {
        let imageURL = URL(string: image)
        NFTImageCache.loadAndCacheImage(for: nftImageView, with: imageURL)
    }

    /**
     Создает `UIImageView` для отображения рейтинга ``NFT``
     
     При вызове метода для каждой ячейки с ``NFT`` очищается `ratingStackView` и снова заполняется при помощи `UIImageView` желтыми или прозрачными звездами в зависимости от рейтинга ``NFT``
     - Parameter rating: Значение ``NFT/rating``
     */
    func setRating(from rating: Int) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for star in 0 ..< 5 {
            let starImageView = UIImageView()
            starImageView.image = (star < rating) ? UIImage.NFTIcon.starActive : UIImage.NFTIcon.starNoActive
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            ratingStackView.addArrangedSubview(starImageView)
        }
    }

    /**
     Преобразует значение цены ``NFT`` в строку с форматированием в виде денежного значения
     - Parameter price: Значение ``NFT/price``
     - Returns: Строка с форматированием в виде денежного значения
     */
    func formatPrice(_ price: Float) -> String {
        let priceString = NumberFormatter
            .currencyFormatter
            .string(from: price as NSNumber) ?? ""
        return priceString + " " + Constants.Cart.currency
    }

    /**
     Метод, который вызывается при нажатии на кнопку удаления ``NFT`` из корзины
     
     Вызывает ``delegate`` ячейки корзины, который будет обрабатывать нажатие кнопки удаления ``NFT`` из корзины
     */
    @objc func removeNftFromCart() {
        guard let nft else { return }
        delegate?.cartCellDidTapRemoveButton(by: nft)
    }
}

// MARK: - Methods

extension CartCell {

    /**
     Настраивает отображение ячейки корзины с информацией о ``NFT``
     - Parameter nft: ``NFT``, для которого необходимо настроить отображение ячейки корзины
     */
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
