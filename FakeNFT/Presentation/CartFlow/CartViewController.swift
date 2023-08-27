import UIKit

final class CartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        addSubviews()
    }
}

private extension CartViewController {
    
    func addSubviews() {
        addSortingButton()
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
}

private extension CartViewController {
    
    @objc func sortingButtonTapped() {
        // TODO: add opening sorting action sheet
    }
}
