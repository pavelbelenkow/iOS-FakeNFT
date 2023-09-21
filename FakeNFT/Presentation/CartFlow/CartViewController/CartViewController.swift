import UIKit

// MARK: - CartViewController class

/**
``CartViewController`` - это контроллер, отображающий ``MyNFT`` в корзине и позволяющий пользователю посмотреть заказ
 
Cодержит ``CartTableView`` с ``MyNFT``, кнопку сортировки, информацию о количестве ``MyNFT`` и их общей стоимости,
 а также кнопку для перехода на экран оплаты заказа и т.д.
*/
final class CartViewController: UIViewController {

    // MARK: - Properties

    /// Кнопка сортировки ``MyNFT``
    private lazy var sortingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.NFTIcon.sorting, for: .normal)
        button.addTarget(
            self,
            action: #selector(sortingButtonTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// Элемент управления для обновления заказа с ``MyNFT``
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(
            self,
            action: #selector(refreshOrder),
            for: .valueChanged
        )
        return control
    }()

    /// Таблица со списком ``MyNFT`` в заказе
    private lazy var cartTableView: UITableView = {
        let view = CartTableView(viewModel: viewModel, viewController: self)
        view.refreshControl = refreshControl
        return view
    }()

    /// Надпись для пустой корзины
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Cart.emptyCartText
        label.textAlignment = .center
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Контейнер для информации о заказе и кнопки оплаты
    private lazy var paymentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NFTColor.lightGray
        view.layer.cornerRadius = Constants.Cart.radius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Вертикальный стек внутри контейнера для размещения информации о заказе
    private lazy var detailStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Надпись о количестве ``MyNFT`` в корзине
    private lazy var nftAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 " + Constants.Cart.nftText
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular15
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Надпись об общей стоимости ``MyNFT`` в корзине
    private lazy var totalValueLabel: UILabel = {
        let label = UILabel()
        label.text = "00,00 " + Constants.Cart.currency
        label.textColor = UIColor.NFTColor.green
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Кнопка для перехода на ``PaymentViewController`` для оплаты заказа
    private lazy var paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .payment, for: Constants.Cart.payment)
        button.addTarget(
            self,
            action: #selector(paymentButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    /// Вью-модель корзины
    private let viewModel: CartViewModelProtocol

    // MARK: - Initializers

    /**
     Создает новый объект ``CartViewController`` с указанной вью-моделью корзины
     - Parameter viewModel: ``CartViewModelProtocol`` корзины
     */
    init(viewModel: CartViewModelProtocol) {
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
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCart()
    }
}

// MARK: - Add Subviews

private extension CartViewController {

    func addSubviews() {
        addSortingButton()
        addCartTableView()
        addEmptyCartLabel()
        addPaymentContainerView()
        addDetailStackView()
        addPaymentButton()
    }

    func addSortingButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortingButton)
    }

    func addCartTableView() {
        view.addSubview(cartTableView)

        NSLayoutConstraint.activate([
            cartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cartTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func addEmptyCartLabel() {
        view.addSubview(emptyCartLabel)

        NSLayoutConstraint.activate([
            emptyCartLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    func addPaymentContainerView() {
        view.addSubview(paymentContainerView)

        NSLayoutConstraint.activate([
            paymentContainerView.heightAnchor.constraint(equalToConstant: 76),
            paymentContainerView.topAnchor.constraint(equalTo: cartTableView.bottomAnchor),
            paymentContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            paymentContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func addDetailStackView() {
        paymentContainerView.addSubview(detailStackView)
        detailStackView.addArrangedSubview(nftAmountLabel)
        detailStackView.addArrangedSubview(totalValueLabel)

        NSLayoutConstraint.activate([
            detailStackView.centerYAnchor.constraint(equalTo: paymentContainerView.centerYAnchor),
            detailStackView.leadingAnchor.constraint(equalTo: paymentContainerView.leadingAnchor, constant: 16)
        ])
    }

    func addPaymentButton() {
        paymentContainerView.addSubview(paymentButton)

        NSLayoutConstraint.activate([
            paymentButton.centerYAnchor.constraint(equalTo: paymentContainerView.centerYAnchor),
            paymentButton.leadingAnchor.constraint(equalTo: detailStackView.trailingAnchor, constant: 24),
            paymentButton.trailingAnchor.constraint(equalTo: paymentContainerView.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Private methods

private extension CartViewController {

    /// Обновляет данные корзины, получая актуальный заказ с помощью ``CartViewModel/getOrder(_:)``
    func updateCart() {
        viewModel.getOrder()
    }

    /// Обновляет надпись с количеством ``MyNFT`` в корзине
    func updateNftAmountLabel() {
        let nftCount = viewModel.listNfts.count
        nftAmountLabel.text = "\(nftCount) " + Constants.Cart.nftText
    }

    /**
     Форматирует значение общей стоимости ``MyNFT`` в корзине
     - Parameter value: Общая стоимость ``MyNFT`` в корзине
     - Returns: Отформатированное значение общей стоимости
     */
    func formatTotalValue(_ value: Float) -> String {
        let valueString = NumberFormatter
            .currencyFormatter
            .string(from: value as NSNumber) ?? ""
        return valueString + " " + Constants.Cart.currency
    }

    /// Обновляет надпись с общей стоимостью ``MyNFT`` в корзине
    func updateTotalValueLabel() {
        let totalValue = viewModel.getNftsTotalValue()
        let formattedTotalValue = formatTotalValue(totalValue)
        totalValueLabel.text = formattedTotalValue
    }

    /// Обновляет интерфейс в зависимости от того,  пустой массив ``CartViewModel/listNfts`` или нет
    func updateUI() {
        let isCartEmpty = viewModel.listNfts.isEmpty

        emptyCartLabel.isHidden = !isCartEmpty
        sortingButton.isHidden = isCartEmpty
        paymentContainerView.isHidden = isCartEmpty

        updateNftAmountLabel()
        updateTotalValueLabel()
    }

    /// Обновляет интерфейс после привязки списка ``MyNFT`` в корзине к вью-модели
    func updateUIAfterBindingNfts() {
        UIBlockingProgressHUD.dismiss()

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.cartTableView.reloadData()
            self.updateUI()
        }
    }

    /// Связывает ``CartViewModel`` с ``CartViewController``, обновляя ``CartTableView`` и интерфейс ``CartViewController``
    func bindViewModel() {
        UIBlockingProgressHUD.show()

        viewModel.bindNfts { [weak self] _ in
            guard let self else { return }
            self.updateUIAfterBindingNfts()
        }
    }

    /// Скроллит ``CartTableView`` в начало списка ``MyNFT`` в корзине, если она не находится там уже
    func scrollToTopIfNeeded() {
        let topIndexPath = IndexPath(row: 0, section: 0)
        if cartTableView.contentOffset.y > 0 {
            cartTableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        } else {
            cartTableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
        }
    }

    /// Отображает `Action Sheet` со списком типов сортировки
    func presentSheetOfSortTypes() {
        let sheetTitle = Constants.Cart.sortText
        let priceSortTitle = Constants.Cart.byPrice
        let rateSortTitle = Constants.Cart.byRating
        let nameSortTitle = Constants.Cart.byTitle
        let closeSheetTitle = Constants.Cart.closeText

        let priceSortAction = UIAlertAction(
            title: priceSortTitle,
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sortBy(option: .price)
            self?.scrollToTopIfNeeded()
        }
        let rateSortAction = UIAlertAction(
            title: rateSortTitle,
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sortBy(option: .rating)
            self?.scrollToTopIfNeeded()
        }
        let nameSortAction = UIAlertAction(
            title: nameSortTitle,
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sortBy(option: .name)
            self?.scrollToTopIfNeeded()
        }
        let closeSheetAction = UIAlertAction(
            title: closeSheetTitle,
            style: .cancel
        )

        let actionSheet = UIAlertController(
            title: sheetTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        let actions = [
            priceSortAction, rateSortAction,
            nameSortAction, closeSheetAction
        ]

        actions.forEach { action in
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true)
    }

    /**
     Обрабатывает результат оплаты заказа
     
     Осуществляет навигацию между контроллерами в зависимости от результата оплаты заказа
     - Если результат успешный - перемещаемся на таб ``CatalogueViewController``
     - Eсли результат неуспешный - возвращаемся в ``CartViewController`` для повторной оплаты
     - Parameter viewModel: ``OrderPaymentViewModel`` оплаты заказа
     */
    func handlePaymentResult(viewModel: OrderPaymentViewModel) {
        viewModel.paymentResultHandler = { [weak self] (isSuccess) in
            guard let self = self else { return }
            if isSuccess {
                self.tabBarController?.selectedIndex = 1
                self.navigationController?.popToRootViewController(animated: false)
                self.viewModel.clearCart()
            } else {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }

    /// Обновляет данные корзины при смахивании вниз в начале таблицы
    @objc func refreshOrder() {
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let self else { return }
            self.refreshControl.endRefreshing()
            self.updateCart()
        }
    }

    /**
     Обрабатывает нажатие на кнопку сортировки в корзине
     
     Вызывает `Action Sheet` со списком типов сортировки
     */
    @objc func sortingButtonTapped() {
        presentSheetOfSortTypes()
    }

    /// Обрабатывает нажатие на кнопку перехода на ``PaymentViewController``
    @objc func paymentButtonTapped() {
        let paymentViewModel = OrderPaymentViewModel()
        let paymentViewController = PaymentViewController(viewModel: paymentViewModel)

        paymentViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(paymentViewController, animated: true)

        handlePaymentResult(viewModel: paymentViewModel)
    }
}

// MARK: - Delegate methods

extension CartViewController: CartCellDelegate {

    func cartCellDidTapRemoveButton(by nft: MyNFT) {
        let viewController = RemoveNftViewController(viewModel: viewModel, nft: nft)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true)
    }
}
