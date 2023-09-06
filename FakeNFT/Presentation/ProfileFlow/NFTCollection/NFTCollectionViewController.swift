import UIKit

final class NFTCollectionViewController: UIViewController {

    private enum Constants {
        static let navBarButtonSize: CGFloat = 42
        static let actionSheetTitle = "Сортировка"
        static let cancelAction = "Отмена"
    }

    private var viewModel = NFTCollectionViewModel()

    var idCollection = [Int]()
    var idLikesCollection = [Int]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        viewModel.ids = idCollection
        viewModel.loadUsersNFT()
        bind()
    }

    // MARK: - UI Objects
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(NFTCollectionCell.self,
                           forCellReuseIdentifier: NFTCollectionCell.reuseIdentifier)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        return tableview
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "NFTSort"), for: .normal)
        button.tintColor = UIColor.NFTColor.black
        let width = Constants.navBarButtonSize
        button.frame.size = CGSize(width: width, height: width)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ChevronLeft"), for: .normal)
        button.tintColor = UIColor.NFTColor.black
        let width = Constants.navBarButtonSize
        button.frame.size = CGSize(width: width, height: width)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Private functions
    private func bind() {
        viewModel.$authorsNames.bind { [weak self] _ in
            self?.tableView.reloadData()
        }

        viewModel.$sortingType.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func sortButtonTapped() {
        showActionSheet()
    }

    private func showActionSheet() {
        let alertController = UIAlertController(title: Constants.actionSheetTitle,
                                                message: nil,
                                                preferredStyle: .actionSheet)

        let sortByPrice = UIAlertAction(title: SortingType.byPrice.rawValue, style: .default) { [weak self] _ in
            self?.viewModel.sort(by: .byPrice)
        }
        let sortByRating = UIAlertAction(title: SortingType.byRating.rawValue, style: .default) { [weak self] _ in
            self?.viewModel.sort(by: .byRating)
        }

        let sortByName = UIAlertAction(title: SortingType.byName.rawValue, style: .default) { [weak self] _ in
            self?.viewModel.sort(by: .byName)
        }

        let cancelAction = UIAlertAction(title: Constants.cancelAction, style: .cancel)

        let actions = [sortByPrice, sortByRating, sortByName, cancelAction]
        actions.forEach { alertController.addAction($0)}
        present(alertController, animated: true)
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = .init(customView: sortButton)
        navigationItem.leftBarButtonItem = .init(customView: backButton)
        title = "Мои NFT"
    }
}

// MARK: - UITableViewDataSource
extension NFTCollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.authorsNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: NFTCollectionCell.reuseIdentifier) as? NFTCollectionCell
        else { return NFTCollectionCell() }
        let nft = viewModel.nfts[indexPath.row]
        let authorName = viewModel.authorsNames[indexPath.row]

        let name = nft.name
        let rating = nft.rating
        let author = authorName
        let price = String(nft.price)
        let id = nft.id
        let isLiked = idLikesCollection.contains(Int(id) ?? 0)
        guard let image = nft.images.first else { return NFTCollectionCell() }
        cell.configCell(name: name, rating: rating, author: author, price: price, image: image, isLiked: isLiked)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NFTCollectionViewController: UITableViewDelegate {

}
