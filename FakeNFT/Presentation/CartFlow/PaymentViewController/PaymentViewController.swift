import UIKit

final class PaymentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        addNavigationBar()
    }
}

private extension PaymentViewController {
    
    func addNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.NFTIcon.chevronLeft,
            style: .plain,
            target: self,
            action: #selector(backToCart)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor.NFTColor.black
    }
}

private extension PaymentViewController {
    
    @objc func backToCart() {
        navigationController?.popViewController(animated: true)
    }
}
