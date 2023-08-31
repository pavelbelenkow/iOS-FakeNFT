//
//  UserCollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import UIKit

final class UserCollectionScreenViewController: UIViewController {
    var ntfTest = [
        NFT(
            createdAt: "хз",
            name: "Вася",
            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
            rating: 3,
            description: "щшопщупщшопщойцщп",
            price: 1.565949,
            author: "5",
            id: "6"
        )
    ]
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
        userNFTsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return userNFTsCollectionView
    }()
    
    private let params = GeometricParams(
        cellCount: 3,
        leftInset: 16,
        rightInset: 16,
        topInset: 0,
        bottomInset: 0,
        cellSpacing: 9
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        makeNavBarWithBackButtonAndTitle()
        addSubviews()
        makeConstraints()
    }
    
    private func makeNavBarWithBackButtonAndTitle() {
        let navBar = self.navigationController?.navigationBar
        let backButton = UIButton(type: .custom)
        backButton.setImage(
            UIImage.NFTIcon.chevronLeft,
            for: .normal
        )
        backButton.addTarget(
            self,
            action: #selector(didBackButton),
            for: .touchUpInside
        )
        let leftNavBarItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftNavBarItem
        self.navigationController?.navigationBar.tintColor = UIColor.NFTColor.black
        self.title = "Коллекция NFT"
        self.navBar = navBar
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
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
    @objc private func didBackButton() {
        navigationController?.popViewController(animated: true)
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
        return 8
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
        return 30
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as UserNFTsCollectionViewCell
        cell.configureUserNFTsCollectionViewCell(
            with: UserNFTsCollectionViewCellModel(
                name: ntfTest[0].name,
                image: URL(string: ntfTest[0].images[0]) ?? URL(fileURLWithPath: String()),
                rating: ntfTest[0].rating,
                price: ntfTest[0].price,
                id: ntfTest[0].id
            )
        )
        
        return cell
    }
}


