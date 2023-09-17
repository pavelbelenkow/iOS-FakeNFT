//
//  NFTScreenVC+UICollectionViewDataSource.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension NFTScreenVC: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        nftScreenViewModel.nftCollection.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NFTScreenCell.identifier, for: indexPath
        ) as? NFTScreenCell else {
            return UICollectionViewCell()
        }

        cell.configCell(with: nftScreenViewModel.nftCollection[indexPath.row], delegate: self)

        return cell
    }

}
