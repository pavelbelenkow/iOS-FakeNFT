//
//  UserCollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import UIKit

final class UserCollectionScreenViewController: UIViewController {
    var nfts: [String]?
    private let viewModel = UserCollectionScreenViewModel()
    private var navBar: UINavigationBar?
    private lazy var userNFTsCollectionView: UICollectionView = {
        let userNFTsCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        userNFTsCollectionView.dataSource = self
        userNFTsCollectionView.delegate = self
        userNFTsCollectionView.register(UserNFTsCollectionViewCell.self)
        userNFTsCollectionView.backgroundColor = .clear
        userNFTsCollectionView.allowsMultipleSelection = false
        userNFTsCollectionView.showsVerticalScrollIndicator = false
        userNFTsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return userNFTsCollectionView
    }()

    private let params = GeometricParams(
        cellCount: 3,
        leftInset: 16,
        rightInset: 16,
        topInset: .zero,
        bottomInset: .zero,
        cellSpacing: 9
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        self.makeNavBarWithBackButtonAndTitle(
            title: "Коллекция NFT",
            isBackedToScreenWithHiddenTabBar: true
        )
        addSubviews()
        makeConstraints()
        bind()
        viewModel.getNFTsUser(nfts: nfts ?? [String()])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissProgressHUD()
    }

    private func bind() {
        viewModel.$nfts.bind { [weak self] _ in
            guard let self = self else { return }
            self.userNFTsCollectionView.reloadData()
        }

        viewModel.$isLoading.bind { [weak self] isLoading in
            guard let self = self else { return }
            self.progressStatus(isLoading)
        }
    }

    private func addSubviews() {
        view.addSubview(userNFTsCollectionView)
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            userNFTsCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            userNFTsCollectionView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor),
            userNFTsCollectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            userNFTsCollectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
}

extension UserCollectionScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellSize = setCellSize(collectionView)
        return CGSize(
            width: cellSize.width,
            height: cellSize.height
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: params.topInset,
            left: params.leftInset,
            bottom: params.bottomInset,
            right: params.rightInset
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.cellSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.cellSpacing
    }

    private func setCellSize(_ collectionView: UICollectionView) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWight
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(
            width: cellWidth,
            height: 192
        )
    }
}

extension UserCollectionScreenViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.nfts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as UserNFTsCollectionViewCell
        cell.configureUserNFTsCollectionViewCell(
            with: viewModel.setUserNFTsCollectionViewCell(indexRow: indexPath.row)
        )
        return cell
    }
}
