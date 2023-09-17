import UIKit

final class FavoritesViewController: UIViewController {

    var idLikesCollection = [Int]()

    private var viewModel: FavoritesViewModel

    private enum Constants {
        static let plugText = "У Вас еще нет избранных  NFT"
        static let title = "Избранные NFT"
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            FavoritesCell.self,
            forCellWithReuseIdentifier: FavoritesCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        activateConstraints()
        viewModel.nftIds = idLikesCollection
        viewModel.loadUsersNFT()
        bind()
    }

    // MARK: - Initializer
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Objc methods
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func bind() {
        viewModel.$nfts.bind { [weak self] nftCollection in
            self?.plugLabel.isHidden = nftCollection.isEmpty ? false : true
            self?.collectionView.reloadData()
        }
    }

}
// MARK: - Setupview functions
private extension FavoritesViewController {
    func setupView() {
        title = Constants.title

        view.backgroundColor = UIColor.NFTColor.white
        view.addSubview(collectionView)
        view.addSubview(plugLabel)
        navigationItem.leftBarButtonItem = .init(customView: backButton)
    }

    func activateConstraints() {
        let edge: CGFloat = 16
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edge),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edge),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            plugLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edge),
            plugLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edge)
        ])
    }
}

extension FavoritesViewController: FavoritesCellDelegate {
    func likeButtonTapped(with nftID: String) {
        viewModel.deleteFromFavorites(by: nftID)
    }
}
// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int { 1 }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.nfts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesCell.reuseIdentifier,
            for: indexPath
        ) as? FavoritesCell else { return FavoritesCell() }
        let arrayNft = Array(viewModel.nfts.values)
        let nft = arrayNft[indexPath.row]
        cell.delegate = self
        cell.configCell(nft: nft)
        return cell
    }

}
// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let height: CGFloat = 80
        let width: CGFloat = screenWidth / 2 - 32

        let size = CGSize(width: width, height: height)
        return size
    }
}
