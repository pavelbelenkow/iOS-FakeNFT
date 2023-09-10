import UIKit

final class FavoritesViewController: UIViewController {

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

    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

extension FavoritesViewController {
    private func setupView() {
        title = "Избранные NFT"

        view.backgroundColor = UIColor.NFTColor.white
        view.addSubview(collectionView)
        navigationItem.leftBarButtonItem = .init(customView: backButton)
    }

    private func activateConstraints() {

    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { .zero }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesCell.reuseIdentifier,
            for: indexPath
        ) as? FavoritesCell else { return FavoritesCell() }

        return cell
    }

}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 10, height: 20)
    }
}
