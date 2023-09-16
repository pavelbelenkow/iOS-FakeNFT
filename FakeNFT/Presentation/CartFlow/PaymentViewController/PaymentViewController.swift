import UIKit
import SafariServices

// MARK: - PaymentViewController class

/**
``PaymentViewController`` - это контроллер, который отображает доступные валюты и позволяет пользователю выбрать валюту для оплаты своего заказа

Отображает ``CurrencyCollectionView`` с доступными валютами вместе с пользовательским соглашением и кнопкой оплаты
*/
final class PaymentViewController: UIViewController {

    // MARK: - Properties

    /// Элемент управления для обновления списка доступных валют
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(
            self,
            action: #selector(refreshCurrencies),
            for: .valueChanged
        )
        return control
    }()

    /// Коллекция для отображения доступных валют
    private lazy var currencyCollectionView: CurrencyCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = CurrencyCollectionView(viewModel: viewModel, layout: layout)
        view.refreshControl = refreshControl
        return view
    }()

    /// Контейнер для пользовательского соглашения и кнопки оплаты
    private lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NFTColor.lightGray
        view.layer.cornerRadius = Constants.Cart.radius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Вертикальный стек-контейнер внутри контейнера для отображения пользовательского соглашения и кнопки оплаты
    private lazy var paymentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Вертикальный стек внутри стека-контейнера для отображения текста и ссылки пользовательского соглашения
    private lazy var userAgreementStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Надпись пользовательского соглашения
    private lazy var userAgreementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Cart.userAgreementText
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular13
        label.numberOfLines = 0
        return label
    }()

    /// Кнопка-ссылка для перехода на пользовательское соглашение в вебе
    private lazy var userAgreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Cart.userAgreementLinkText, for: .normal)
        button.setTitleColor(UIColor.NFTColor.blue, for: .normal)
        button.addTarget(
            self,
            action: #selector(userAgreementButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    /// Кнопка для оплаты заказа с выбранной валютой
    private lazy var paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(
            with: .payment,
            for: Constants.Cart.pay,
            height: 60
        )
        button.addTarget(
            self,
            action: #selector(paymentButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    /// Вью-модель оплаты заказа
    private let viewModel: OrderPaymentViewModelProtocol

    // MARK: - Initializers

    /**
     Создает новый объект ``PaymentViewController`` с указанной вью-моделью оплаты заказа
     - Parameter viewModel: ``OrderPaymentViewModelProtocol`` для оплаты заказа
     */
    init(viewModel: OrderPaymentViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        addSubviews()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrencies()
    }
}

// MARK: - Add Subviews

private extension PaymentViewController {

    func addSubviews() {
        addNavigationBar()
        addCurrencyCollectionView()
        addPaymentView()
        addPaymentStackView()
        addPaymentContent()
    }

    func addNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.NFTIcon.chevronLeft,
            style: .plain,
            target: self,
            action: #selector(backToCart)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor.NFTColor.black

        title = Constants.Cart.selectTypeOfPayment
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.NFTFont.bold17,
            .foregroundColor: UIColor.NFTColor.black
        ]
    }

    func addCurrencyCollectionView() {
        view.addSubview(currencyCollectionView)

        NSLayoutConstraint.activate([
            currencyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currencyCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func addPaymentView() {
        view.addSubview(paymentView)

        NSLayoutConstraint.activate([
            paymentView.topAnchor.constraint(equalTo: currencyCollectionView.bottomAnchor),
            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func addPaymentStackView() {
        paymentView.addSubview(paymentStackView)

        NSLayoutConstraint.activate([
            paymentStackView.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            paymentStackView.bottomAnchor.constraint(equalTo: paymentView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            paymentStackView.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            paymentStackView.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16)
        ])
    }

    func addPaymentContent() {
        paymentStackView.addArrangedSubview(userAgreementStackView)
        paymentStackView.addArrangedSubview(paymentButton)

        userAgreementStackView.addArrangedSubview(userAgreementTitleLabel)
        userAgreementStackView.addArrangedSubview(userAgreementButton)
    }
}

// MARK: - Private methods

private extension PaymentViewController {

    /**
     Отображает диалоговое окно с сообщением об ошибке при получении списка валют, и кнопками "Повторить" и "Отменить"
     - Parameter error: Ошибка, которая будет отображена в диалоговом окне
     */
    func showCurrenciesErrorAlert(_ error: Error) {
        let errorData = NetworkErrorHandler.handleError(error)

        showAlert(
            title: errorData.title,
            message: errorData.message
        ) { [weak self] in
            UIBlockingProgressHUD.show()

            DispatchQueue.main.async {
                self?.updateCurrencies()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }

    /// Обновляет данные коллекции, получая актуальный список валют
    func updateCurrencies() {
        viewModel.getCurrencies { [weak self] error in
            self?.showCurrenciesErrorAlert(error)
        }
    }

    /// Связывает вью-модель с контроллером, обновляя коллекцию с списком доступных валют
    func bindViewModel() {
        UIBlockingProgressHUD.show()

        viewModel.bindCurrencies { [weak self] _ in
            guard let self else { return }
            self.currencyCollectionView.reloadData()
            UIBlockingProgressHUD.dismiss()
        }
    }

    /// Отображает диалоговое окно с сообщением об ошибке и кнопкой "OK", если пользователь не выбрал валюту для оплаты
    func showUnselectedCurrencyAlert() {
        showAlert(
            title: Constants.Cart.unselectedPaymentMethod,
            message: Constants.Cart.selectCurrencyForPayment,
            retryTitle: Constants.Cart.ok
        )
    }

    /**
     Отображает экран с результатом оплаты
     - Parameter isSuccess: Флаг успешности оплаты - ``PaymentResultNetworkModel/success``
     */
    func showViewController(_ isSuccess: Bool) {
        let viewController = PaymentResultViewController(isSuccess, viewModel: viewModel)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(viewController, animated: true)
    }

    /**
     Отображает диалоговое окно с сообщением об ошибке при запросе на оплату заказа, кнопками "Повторить" и "Отменить"
     - Parameter error: Ошибка, которая будет отображена в диалоговом окне
     */
    func showPaymentErrorAlert(_ error: Error) {
        let errorData = NetworkErrorHandler.handleError(error)

        showAlert(
            title: errorData.title,
            message: errorData.message
        ) { [weak self] in
            UIBlockingProgressHUD.show()

            DispatchQueue.main.async {
                self?.paymentButtonTapped()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }

    /// Обрабатывает нажатие на шеврон в навигационном баре и возвращает на ``CartViewController``
    @objc func backToCart() {
        navigationController?.popViewController(animated: true)
    }

    /// Обновляет список валют при смахивании вниз в начале коллекции
    @objc func refreshCurrencies() {
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self else { return }
            self.refreshControl.endRefreshing()
            self.updateCurrencies()
        }
    }

    /**
     Обрабатывает нажатие на ссылку пользовательского соглашения
     
     Показывает пользовательское соглашение в контроллере просмотра Safari
     */
    @objc func userAgreementButtonTapped() {
        guard let url = URL(string: Constants.Cart.userAgreementURL) else {
            return
        }

        let safariViewController = SFSafariViewController(url: url)
        navigationController?.present(safariViewController, animated: true)
    }

    /**
     Обрабатывает нажатие на кнопку оплаты заказа с выбранной валютой
     
     - Если пользователь уже выбрал валюту для оплаты, то метод получает результат оплаты заказа с помощью выбранной валюты:
        - Если оплата прошла успешно, метод отображает ``PaymentResultViewController``
        - Если произошла ошибка при оплате, метод отображает сообщение с информацией об ошибке
     - Если пользователь не выбрал валюту для оплаты, метод отображает диалоговое окно с просьбой выбрать валюту
     */
    @objc func paymentButtonTapped() {
        guard let selectedIndexPath = currencyCollectionView.selectedIndexPath else {
            showUnselectedCurrencyAlert()
            return
        }

        let selectedCurrency = viewModel.listCurrencies[selectedIndexPath.row]

        viewModel.getOrderPaymentResult(by: selectedCurrency.id) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let isSuccess):
                self.showViewController(isSuccess)
            case .failure(let error):
                self.showPaymentErrorAlert(error)
            }
        }
    }
}
