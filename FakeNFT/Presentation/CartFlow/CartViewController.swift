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
            cartTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
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
}
