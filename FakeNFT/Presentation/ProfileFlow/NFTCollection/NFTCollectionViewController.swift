import UIKit

final class NFTCollectionViewController: UIViewController {

    private enum Constants {
        static let navBarButtonSize: CGFloat = 42
        static let actionSheetTitle = "Сортировка"
        static let cancelAction = "Закрыть"
        static let plugText = "У Вас ещё нет NFT"
    }

    private var viewModel: NFTCollectionViewModel

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

    // MARK: - Initializer
    init(viewModel: NFTCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Objects
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(NFTCollectionCell.self,
                           forCellReuseIdentifier: NFTCollectionCell.reuseIdentifier)
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

    private lazy var backButton: NavBarBackButton = {
        let button = NavBarBackButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var plugLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.text = Constants.plugText
        label.textAlignment = .center
        label.isHidden = false
        return label
    }()

    // MARK: - Private functions
    private func bind() {
        viewModel.$authorsNames.bind { [weak self] authors in
            self?.plugLabel.isHidden = authors.isEmpty ? false : true
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

        let sortByPrice = UIAlertAction(
            title: SortingType.byPrice.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sort(by: .byPrice)
        }
        let sortByRating = UIAlertAction(
            title: SortingType.byRating.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sort(by: .byRating)
        }

        let sortByName = UIAlertAction(
            title: SortingType.byName.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.viewModel.sort(by: .byName)
        }

        let cancelAction = UIAlertAction(
            title: Constants.cancelAction,
            style: .cancel
        )

        let actions = [sortByPrice, sortByRating, sortByName, cancelAction]
        actions.forEach { alertController.addAction($0)}
        present(alertController, animated: true)
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(plugLabel)
        let edge: CGFloat = 16
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            plugLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edge),
            plugLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edge)
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

        let author = authorName
        let id = nft.id
        let isLiked = idLikesCollection.contains(Int(id) ?? 0)
        guard let image = nft.images.first else { return NFTCollectionCell() }
        cell.configCell(nft: nft, author: author, isLiked: isLiked)
        return cell
    }
}
