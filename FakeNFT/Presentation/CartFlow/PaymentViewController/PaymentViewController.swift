import UIKit

// MARK: - PaymentViewController class

final class PaymentViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var currencyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = CurrencyCollectionView(viewController: self, layout: layout)
        return view
    }()
    
    private lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.NFTColor.lightGray
        view.layer.cornerRadius = Constants.Cart.radius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userAgreementStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userAgreementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Cart.userAgreementText
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular13
        return label
    }()
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        addSubviews()
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
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
    
    @objc func backToCart() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func userAgreementButtonTapped() {
        // TODO: impl segue to agreement in web view/ SFSafariVC
    }
    
    @objc func paymentButtonTapped() {
        // TODO: impl segue to success or failure paymentVC
    }
}
