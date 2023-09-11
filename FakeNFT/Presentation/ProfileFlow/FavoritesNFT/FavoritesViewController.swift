import UIKit

final class FavoritesViewController: UIViewController {

    var idLikesCollection = [Int]()

    private var viewModel = FavoritesViewModel()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        activateConstraints()
        viewModel.nftIds = idLikesCollection
        viewModel.loadUsersNFT()
        bind()
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func bind() {
        viewModel.$nfts.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }

}
// MARK: - Setupview functions
private extension FavoritesViewController {
    func setupView() {
        title = "Избранные NFT"

        view.backgroundColor = UIColor.NFTColor.white
        view.addSubview(collectionView)
        navigationItem.leftBarButtonItem = .init(customView: backButton)
    }

    func activateConstraints() {
        let edge: CGFloat = 16
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edge),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edge),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        let nft = viewModel.nfts[indexPath.row]
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
