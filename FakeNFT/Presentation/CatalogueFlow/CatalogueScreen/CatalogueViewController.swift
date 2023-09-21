import UIKit
import ProgressHUD

final class CatalogueViewController: UIViewController {
    // MARK: Internal Properties
    lazy var catalogueView = CatalogueView(dataSource: self, delegate: self)
    var catalogueViewModel = CatalogueViewModel()

    // MARK: View Controller Life Cycle
    override func loadView() {
        view = catalogueView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        bind()
        getCatalogue()
        RateManager.showRatesController()
    }

    // MARK: Private Methods
    private func setNavigationBar() {
        let image = UIImage.NFTIcon.sorting
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 21, weight: .semibold
        )
        let largeImage = image.withConfiguration(imageConfig)

        let rightBarButton = UIBarButtonItem(
            image: largeImage,
            style: .plain,
            target: self,
            action: #selector(showBottomSheet)
        )
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.NFTColor.black

        navigationController?.navigationBar.barTintColor = UIColor.NFTColor.white
    }

    private func bind() {
        catalogueViewModel.$catalogue.bind { [weak self] _ in
            guard let self else { return }
            self.catalogueView.reloadTableView()
        }
    }

    @objc
    private func showBottomSheet() {
        let alertController = UIAlertController(
            title: NSLocalizedString("Сортировка", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )

        let nameSorting = UIAlertAction(
            title: NSLocalizedString("По названию", comment: ""),
            style: .default
        ) { [weak self] _ in
            self?.catalogueViewModel.sortByName()
        }

        let countSorting = UIAlertAction(
            title: NSLocalizedString("По количеству NFT", comment: ""),
            style: .default
        ) { [weak self] _ in
            self?.catalogueViewModel.sortByCount()
        }

        let cancel = UIAlertAction(
            title: NSLocalizedString("Закрыть", comment: ""),
            style: .cancel
        )

        [nameSorting, countSorting, cancel].forEach { item in
            alertController.addAction(item)
        }

        present(alertController, animated: true, completion: nil)
    }

    private func getCatalogue() {
        ProgressHUD.show()
        catalogueViewModel.getCatalogue { result in
            switch result {
            case .success(()):
                ProgressHUD.dismiss()
            case .failure:
                ProgressHUD.showFailed()
                let errorView = ErrorView()
                self.view = errorView
            }
        }
    }
}
