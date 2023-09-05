import UIKit

// MARK: - PaymentViewController class

final class PaymentViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var currencyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = CurrencyCollectionView(viewController: self, layout: layout)
        return view
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
            currencyCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            currencyCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - Private methods

private extension PaymentViewController {
    
    @objc func backToCart() {
        navigationController?.popViewController(animated: true)
    }
}
