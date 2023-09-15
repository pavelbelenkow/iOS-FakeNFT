//
//  UserInfoScreenViewController.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import UIKit

final class UserInfoScreenViewController: UIViewController {
    var userId: String?
    private let viewModel = UserInfoScreenViewModel()
    private let analyticsService = AnalyticsService()
    private var website = ""
    private var navBar: UINavigationBar?
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = .clear
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private lazy var avatarAndNameView: UIView = {
        let avatarAndNameView = UIView()
        avatarAndNameView.backgroundColor = .clear
        avatarAndNameView.translatesAutoresizingMaskIntoConstraints = false
        return avatarAndNameView
    }()
    
    private lazy var descriptionView: UIView = {
        let descriptionView = UIView()
        descriptionView.backgroundColor = .clear
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.NFTFont.bold22
        nameLabel.textColor = UIColor.NFTColor.black
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.NFTFont.regular13
        descriptionLabel.textColor = UIColor.NFTColor.black
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = .zero
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var goToSiteUserButton: UIButton = {
        let goToSiteUserButton = UIButton()
        goToSiteUserButton.setTitle(
            "Перейти на сайт пользователя",
            for: .normal
        )
        goToSiteUserButton.titleLabel?.font = UIFont.NFTFont.regular15
        goToSiteUserButton.setTitleColor(
            UIColor.NFTColor.black,
            for: .normal
        )
        goToSiteUserButton.layer.borderWidth = 1
        goToSiteUserButton.layer.cornerRadius = 16
        goToSiteUserButton.layer.borderColor = UIColor.NFTColor.black.cgColor
        goToSiteUserButton.addTarget(
            self,
            action: #selector(didGoToSiteUserButton),
            for: .touchUpInside
        )
        goToSiteUserButton.translatesAutoresizingMaskIntoConstraints = false
        return goToSiteUserButton
    }()
    
    private lazy var collectionNFTTableView: UITableView = {
        let collectionNFTTableView = UITableView()
        collectionNFTTableView.dataSource = self
        collectionNFTTableView.delegate = self
        collectionNFTTableView.backgroundColor = .clear
        collectionNFTTableView.rowHeight = 54.0
        collectionNFTTableView.separatorStyle = .none
        collectionNFTTableView.bounces = false
        collectionNFTTableView.register(CollectionNFTTableViewCell.self)
        collectionNFTTableView.translatesAutoresizingMaskIntoConstraints = false
        return collectionNFTTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        self.makeNavBarWithBackButtonAndTitle(
            title: ""
        )
        addSubviews()
        makeConstraints()
        bind()
        viewModel.getInfoUser(userId: userId ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissProgressHUD()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *),
           traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                goToSiteUserButton.layer.borderColor = UIColor.NFTColor.whiteUniversal.cgColor
            } else {
                goToSiteUserButton.layer.borderColor = UIColor.NFTColor.blackUniversal.cgColor
            }
        }
    }
    
    private func bind() {
        viewModel.$user.bind { [weak self] _ in
            guard let self = self else { return }
            self.setUserInfo(with: self.viewModel.setUserInfo())
        }
        
        viewModel.$isLoading.bind { [weak self] isLoading in
            guard let self = self else { return }
            self.progressStatus(isLoading)
        }
    }
    
    private func addSubviews() {
        avatarAndNameView.addSubview(avatarImageView)
        avatarAndNameView.addSubview(nameLabel)
        descriptionView.addSubview(descriptionLabel)
        cardView.addSubview(avatarAndNameView)
        cardView.addSubview(descriptionView)
        view.addSubview(cardView)
        view.addSubview(goToSiteUserButton)
        view.addSubview(collectionNFTTableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 162),
            cardView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            cardView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor
            ),
            cardView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
        
        NSLayoutConstraint.activate([
            avatarAndNameView.heightAnchor.constraint(equalToConstant: 70),
            avatarAndNameView.topAnchor.constraint(equalTo: cardView.topAnchor),
            avatarAndNameView.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 16
            ),
            avatarAndNameView.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -16
            )
        ])
        
        NSLayoutConstraint.activate([
            descriptionView.heightAnchor.constraint(equalToConstant: 72),
            descriptionView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: avatarAndNameView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: avatarAndNameView.leadingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarAndNameView.bottomAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: avatarAndNameView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 16
            ),
            nameLabel.trailingAnchor.constraint(equalTo: avatarAndNameView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: descriptionView.leadingAnchor,
                constant: 16
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: descriptionView.trailingAnchor,
                constant: -16
            )
        ])
        
        NSLayoutConstraint.activate([
            goToSiteUserButton.heightAnchor.constraint(equalToConstant: 40),
            goToSiteUserButton.topAnchor.constraint(
                equalTo: cardView.bottomAnchor,
                constant: 28
            ),
            goToSiteUserButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            goToSiteUserButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            )
        ])
        
        NSLayoutConstraint.activate([
            collectionNFTTableView.heightAnchor.constraint(equalToConstant: 54),
            collectionNFTTableView.topAnchor.constraint(
                equalTo: goToSiteUserButton.bottomAnchor,
                constant: 40
            ),
            collectionNFTTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionNFTTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setUserInfo(with model: UserInfoSetModel) {
        avatarImageView.loadImage(url: model.avatar)
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        website = model.website
        collectionNFTTableView.reloadData()
    }
    
    @objc private func didGoToSiteUserButton() {
        analyticsService.report(
            screen: .screenStatistic,
            event: .click,
            param: .userSiteStatistic
        )
        let webViewUserWebsiteVC = WebViewVC()
        webViewUserWebsiteVC.urlString = website
        navigationController?.pushViewController(
            webViewUserWebsiteVC,
            animated: true
        )
    }
}

extension UserInfoScreenViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as CollectionNFTTableViewCell
        cell.configureCollectionNFTTableViewCell(countCollectionNFT: viewModel.setCountCollectionNFT())

        return cell
    }
}

extension UserInfoScreenViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let nfts = viewModel.getNFTs() else { return }
        analyticsService.report(
            screen: .screenStatistic,
            event: .click,
            param: .collectionUserNFTsStatistic
        )
        let userCollectionScreenVC = UserCollectionScreenViewController()
        userCollectionScreenVC.nfts = nfts
        navigationController?.pushViewController(
            userCollectionScreenVC,
            animated: true
        )
    }
}


