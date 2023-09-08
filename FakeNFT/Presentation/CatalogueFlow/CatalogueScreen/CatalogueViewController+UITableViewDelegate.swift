//
//  CatalogueViewController+UITableViewDelegate.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

//MARK: - UITableViewDelegate
extension CatalogueViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let NFTScreenVC = NFTScreenVC(catalogueCell: catalogueViewModel.catalogue[indexPath.row])
        let backItem = UIBarButtonItem()
        backItem.title = String()
        NFTScreenVC.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(NFTScreenVC, animated: true)
    }
}
