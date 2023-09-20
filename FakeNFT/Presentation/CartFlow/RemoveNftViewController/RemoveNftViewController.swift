import UIKit

// MARK: - RemoveNftViewController class

/**
 ``RemoveNftViewController`` - это контроллер, который отображает экран удаления ``MyNFT`` из корзины

 Содержит ``MyNFT/image``, кнопки для удаления ``MyNFT`` и возврата в ``CartViewController`` и т.д.
 */
final class RemoveNftViewController: UIViewController {

    // MARK: - Properties

    /// Эффект размытия для фона вью
    private lazy var blurEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.frame = self.view.bounds
        return view
    }()

    /// Вертикальный стек-контейнер с информацией об удаляемом ``MyNFT`` и кнопками
    private lazy var nftContainerView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.alignment = .center
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Контейнер для изображения ``MyNFT`` и надписи подтверждения удаления
    private lazy var detailNftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Изображение ``MyNFT``
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Constants.Cart.radius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Надпись подтверждения удаления ``MyNFT``
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Cart.removeFromCart
        label.textAlignment = .center
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular13
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Горизонтальный стек для кнопок удаления и возврата в корзину
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Кнопка для подтверждения удаления ``MyNFT`` из корзины
    private lazy var removeNftButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(
            with: .other,
            for: Constants.Cart.remove,
            titleColor: UIColor.NFTColor.red
        )
        button.addTarget(
            self,
            action: #selector(removeNftFromCart),
            for: .touchUpInside
        )
        return button
    }()

    /// Кнопка для отмены подтверждения удаления ``MyNFT`` из корзины
    private lazy var cancelActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .other, for: Constants.Cart.back)
        button.addTarget(
            self,
            action: #selector(dismissViewController),
            for: .touchUpInside
        )
        return button
    }()

    /// Вью-модель корзины
    private let viewModel: CartViewModelProtocol

    /// Удаляемый ``MyNFT``
    private var nft: MyNFT?

    // MARK: - Initializers

    /**
     Создает новый объект ``RemoveNftViewController`` с указанной вью-моделью корзины
     - Parameters:
        - viewModel: ``CartViewModelProtocol`` корзины
        - nft: ``MyNFT``, который нужно удалить
     */
    init(viewModel: CartViewModelProtocol, nft: MyNFT) {
        self.viewModel = viewModel
        self.nft = nft
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addSubviews()
        setNftImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateBlurEffect()
    }
}

// MARK: - Add Subviews

private extension RemoveNftViewController {

    func addSubviews() {
        view.addSubview(blurEffectView)
        addNftContainerView()
        addDetailNftView()
        addButtonStackView()
    }

    func addNftContainerView() {
        view.addSubview(nftContainerView)

        NSLayoutConstraint.activate([
            nftContainerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            nftContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 56),
            nftContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -56)
        ])
    }

    func addDetailNftView() {
        nftContainerView.addArrangedSubview(detailNftView)
        detailNftView.addSubview(nftImageView)
        detailNftView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            detailNftView.leadingAnchor.constraint(equalTo: nftContainerView.leadingAnchor, constant: 41),
            detailNftView.trailingAnchor.constraint(equalTo: nftContainerView.trailingAnchor, constant: -41),

            nftImageView.heightAnchor.constraint(equalToConstant: Constants.Cart.nftImageHeight),
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.Cart.nftImageHeight),
            nftImageView.topAnchor.constraint(equalTo: detailNftView.topAnchor),
            nftImageView.centerXAnchor.constraint(equalTo: detailNftView.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: detailNftView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: detailNftView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: detailNftView.bottomAnchor)
        ])
    }

    func addButtonStackView() {
        nftContainerView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(removeNftButton)
        buttonStackView.addArrangedSubview(cancelActionButton)

        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: nftContainerView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: nftContainerView.trailingAnchor)
        ])
    }
}

// MARK: - Private methods

private extension RemoveNftViewController {

    /// Анимирует эффект размытия фона
    func animateBlurEffect() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blurEffectView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        }
    }

    /**
     Загружает и кэширует изображение ``MyNFT`` с помощью ``NFTImageCache/loadAndCacheImage(for:with:)``,
     и устанавливает его в `nftImageView`
     */
    func setNftImage() {
        guard let nft else { return }
        let imageURL = URL(string: nft.image)
        NFTImageCache.loadAndCacheImage(for: nftImageView, with: imageURL)
    }

    /**
     Метод, который вызывается при нажатии на кнопку подтверждения удаления ``MyNFT`` из корзины
     
     Вызывает метод ``CartViewModelProtocol/removeNft(by:_:)``, который будет выполнять запрос ``CartServiceProtocol/putOrder(with:_:)``
      - В случае успешности запроса - ``MyNFT`` будет удалена из ``CartTableView`` и в ``OrderNetworkModel`` на сервере
      - В случае неуспешности запроса - будет показано диалоговое окно с ошибкой удаления
     */
    @objc func removeNftFromCart() {
        guard let nft else { return }

        viewModel.removeNft(by: nft.id) { [weak self] error in
            guard let self else { return }

            if let error {
                UIBlockingProgressHUD.showError(
                    with: Constants.Cart.failedToRemoveNft,
                    icon: .exclamation
                )
                dismiss(animated: true)
                print(error)
            } else {
                dismiss(animated: true)
            }
        }
    }

    /**
     Обрабатывает нажатие на кнопку отмены подтверждения удаления ``MyNFT`` из корзины
     
     Cкрывает ``RemoveNftViewController``
     */
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}
