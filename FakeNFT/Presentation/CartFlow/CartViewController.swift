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
