import UIKit

// MARK: - PaymentViewController class

final class PaymentViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        addNavigationBar()
    }
}

// MARK: - Add Subviews

private extension PaymentViewController {
    
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
}

private extension PaymentViewController {
    
    @objc func backToCart() {
        navigationController?.popViewController(animated: true)
    }
}
