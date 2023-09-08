//
//  CatalogueView.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

final class CatalogueView: UIView {
    //MARK: Private Properties
    private let tableView: UITableView = {
        let view = UITableView()

        view.register(
            CatalogueCell.self, forCellReuseIdentifier: CatalogueCell.identifier
        )
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    convenience init(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        self.init()
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }

    //MARK: Private Methods
    private func makeView() {
        addSubviews()
        applyConstraints()
    }

    private func addSubviews() {
        addSubview(tableView)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            tableView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            )
        ])
    }

    //MARK: Internal Methods
    func reloadTableView() {
        tableView.reloadData()
    }
}
