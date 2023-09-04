import UIKit

final class CatalogueViewController: UIViewController {
    //MARK: Internal Properties
    lazy var catalogueView = CatalogueView(dataSource: self, delegate: self)
    var catalogueViewModel = CatalogueViewModel()

    //MARK: View Controller Life Cycle
    override func loadView() {
        view = catalogueView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        view.backgroundColor = UIColor.NFTColor.white
        bind()
        catalogueViewModel.getCatalogue()
    }

    //MARK: Private Methods
    private func setNavigationBar() {
        let image = UIImage(named: "Sorting")
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 21, weight: .semibold
        )
        let largeImage = image?.withConfiguration(imageConfig)

        let rightBarButton = UIBarButtonItem(
            image: largeImage,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = .black

        navigationController?.navigationBar.barTintColor = .white
    }

    private func bind() {
        catalogueViewModel.$catalogue.bind { [weak self] catalogue in
            self?.catalogueView.reloadTableView()
        }
    }
}
