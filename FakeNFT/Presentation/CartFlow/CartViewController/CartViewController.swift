import UIKit

// MARK: - CartViewController class

final class CartViewController: UIViewController {
    
    // MARK: - Properties
    
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
    
    private lazy var cartTableView: UITableView = {
        let view = CartTableView(viewModel: viewModel, viewController: self)
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(
            self,
            action: #selector(refreshOrder),
            for: .valueChanged
        ) 
        cartTableView.refreshControl = control
        return control
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Cart.emptyCartText
        label.textAlignment = .center
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NFTColor.lightGray
        view.layer.cornerRadius = Constants.Cart.radius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var detailStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0" + Constants.Cart.nftText
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular15
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        let label = UILabel()
        label.text = "00,00" + Constants.Cart.currency
        label.textColor = UIColor.NFTColor.green
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    private let viewModel: CartViewModelProtocol
    
    // MARK: - Initializers
    
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
    
    func showErrorAlert(_ error: Error) {
        showAlert(
            title: Constants.Cart.errorAlertTitle,
            message: error.localizedDescription
        ) { [weak self] in
            UIBlockingProgressHUD.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self?.updateCart()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func updateCart() {
        refreshControl.endRefreshing()
        
        viewModel.getOrder { [weak self] error in
            self?.showErrorAlert(error)
        }
    }
    
    func updateNftAmountLabel() {
        let nftCount = viewModel.listNfts.count
        nftAmountLabel.text = "\(nftCount) " + Constants.Cart.nftText
    }
    
    func formatTotalValue(_ value: Float) -> String {
        let valueString = NumberFormatter
            .currencyFormatter
            .string(from: value as NSNumber) ?? ""
        return valueString + " " + Constants.Cart.currency
    }
    
    func updateTotalValueLabel() {
        let totalValue = viewModel.getNftsTotalValue()
        let formattedTotalValue = formatTotalValue(totalValue)
        totalValueLabel.text = formattedTotalValue
    }
    
    func updateUI() {
        let isCartEmpty = viewModel.listNfts.isEmpty
        
        emptyCartLabel.isHidden = !isCartEmpty
        sortingButton.isHidden = isCartEmpty
        cartTableView.isHidden = isCartEmpty
        paymentContainerView.isHidden = isCartEmpty
        updateNftAmountLabel()
        updateTotalValueLabel()
    }
    
    func updateUIAfterBindingNfts() {
        UIBlockingProgressHUD.dismiss()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.cartTableView.reloadData()
            self.updateUI()
        }
    }
    
    func bindViewModel() {
        UIBlockingProgressHUD.show()
        
        viewModel.bindNfts { [weak self] _ in
            guard let self else { return }
            self.updateUIAfterBindingNfts()
        }
    }
    
    func scrollToTopIfNeeded() {
        let topIndexPath = IndexPath(row: 0, section: 0)
        if cartTableView.contentOffset.y > 0 {
            cartTableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        } else {
            cartTableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
        }
    }

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
    
    @objc func refreshOrder() {
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.updateCart()
        }
    }
    
    @objc func sortingButtonTapped() {
        presentSheetOfSortTypes()
    }
    
    @objc func paymentButtonTapped() {
        let paymentViewController = PaymentViewController()
        navigationController?.pushViewController(paymentViewController, animated: true)
    }
}

// MARK: - Delegate methods

extension CartViewController: CartCellDelegate {
    
    func cartCellDidTapRemoveButton(by nft: NFT) {
        let viewController = RemoveNftViewController(viewModel: viewModel, nft: nft)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true)
    }
}
