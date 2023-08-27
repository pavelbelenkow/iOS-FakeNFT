import UIKit

final class CartViewController: UIViewController {
    
    private lazy var cartTableView: UITableView = {
        let view = CartTableView(viewController: self)
        return view
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.textAlignment = .center
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NFTColor.lightGray
        view.layer.cornerRadius = 12
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
        label.text = "0 NFT"
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular15
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalValueLabel: UILabel = {
        let label = UILabel()
        label.text = "00,00 ETH"
        label.textColor = UIColor.NFTColor.green
        label.font = UIFont.NFTFont.bold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .payment, for: "К оплате")
        button.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        addSubviews()
    }
}

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.NFTIcon.sorting,
            style: .done,
            target: self,
            action: #selector(sortingButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor.NFTColor.black
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

private extension CartViewController {
    
    func presentSheetOfSortTypes() {
        let sheetTitle = "Сортировка"
        let priceSortTitle = "По цене"
        let rateSortTitle = "По рейтингу"
        let nameSortTitle = "По названию"
        let closeSheetTitle = "Закрыть"
        
        let priceSortAction = UIAlertAction(title: priceSortTitle, style: .default)
        let rateSortAction = UIAlertAction(title: rateSortTitle, style: .default)
        let nameSortAction = UIAlertAction(title: nameSortTitle, style: .default)
        let closeSheetAction = UIAlertAction(title: closeSheetTitle, style: .cancel)
        
        let actionSheet = UIAlertController(title: sheetTitle, message: nil, preferredStyle: .actionSheet)
        let actions = [priceSortAction, rateSortAction, nameSortAction, closeSheetAction]
        
        actions.forEach { action in
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true)
    }
    
    @objc func sortingButtonTapped() {
        presentSheetOfSortTypes()
    }
    
    @objc func paymentButtonTapped() {
        let paymentViewController = PaymentViewController()
        navigationController?.pushViewController(paymentViewController, animated: true)
    }
}
