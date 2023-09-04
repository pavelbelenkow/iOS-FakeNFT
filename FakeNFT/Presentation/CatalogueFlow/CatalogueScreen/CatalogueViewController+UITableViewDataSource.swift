//
//  CatalogueViewController+UITableViewDataSource.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

//MARK: - UITableViewDataSource
extension CatalogueViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        catalogueViewModel.catalogue.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogueCell.identifier
        ) as? CatalogueCell else { return UITableViewCell() }

        cell.model = catalogueViewModel.catalogue[indexPath.row]

        return cell
    }
}
