import UIKit

final class ProfileViewController: UIViewController {

    private let profileViewModel = ProfileViewModel()

    private var myNFTs = 0
    private var favoriteNFTs = 0

    private var idCollectionNFT = [Int]()
    private var idLikesNFT = [Int]()

    private struct ProfileConstants {
        static let editButtonSize: CGFloat = 42
        static let avatarSize: CGFloat = 70
        static let cellHeight: CGFloat = 54
        static let myNFTtitle = "Мои NFT"
        static let favoritesNFTtitle = "Избранные NFT"
        static let aboutDeveloper = "О разработчике"
        static let cellTitles = [myNFTtitle, favoritesNFTtitle]
    }

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ProfileEdit"), for: .normal)
        button.tintColor = UIColor.NFTColor.black
        let width = ProfileConstants.editButtonSize
        button.frame.size = CGSize(width: width, height: width)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var avatarAndNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.NFTColor.black
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = .zero
        label.font = .headline3
        label.textColor = .black
        return label
    }()

    private lazy var descriptionlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        label.text = ""
        return label
    }()

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.NFTColor.blue
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            ProfileViewCell.self,
            forCellReuseIdentifier: ProfileViewCell.reuseIdentifier
        )
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        bind()
        setupView()
        activateConstraints()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileViewModel.getUserInfo()
    }

    // MARK: - Private functions
    private func bind() {
        profileViewModel.$user.bind { [weak self] user in
            guard let user else { return }
            self?.nameLabel.text = user.name
            self?.descriptionlabel.text = user.description
            self?.websiteLabel.text = user.website
            self?.avatarImage.loadImage(url: user.avatar.toURL,
                                        cornerRadius: ProfileConstants.avatarSize/2)
            self?.myNFTs = user.nfts.count
            self?.favoriteNFTs = user.likes.count
            self?.tableView.reloadData()
        }
    }

    @objc
    private func editButtonTapped() {
        showEditProfile()
    }

    // MARK: - Transtitions to other VC
    private func showEditProfile() {
        let viewController = EditProfileViewController()
        viewController.profileViewModel = profileViewModel
        let nvc = UINavigationController(rootViewController: viewController)
        present(nvc, animated: true)
    }

    private func showMyNFTs() {
        let viewController = NFTCollectionViewController()
        viewController.hidesBottomBarWhenPushed = true
        guard let user = profileViewModel.user else { return }
        idCollectionNFT = user.nfts.compactMap {Int($0)}
        idLikesNFT = user.likes.compactMap {Int($0)}
        viewController.idCollection = idCollectionNFT
        viewController.idLikesCollection = idLikesNFT
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showFavorites() {
        let viewController = FavoritesViewController()
        viewController.hidesBottomBarWhenPushed = true
        guard let user = profileViewModel.user else { return }
        idLikesNFT = user.likes.compactMap {Int($0)}
        viewController.idLikesCollection = idLikesNFT
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Setup view
    private func setupView() {
        setupNavBar()
        view.addSubview(avatarAndNameStackView)
        avatarAndNameStackView.addArrangedSubview(avatarImage)
        avatarAndNameStackView.addArrangedSubview(nameLabel)
        view.addSubview(descriptionlabel)
        view.addSubview(websiteLabel)
        view.addSubview(tableView)
    }

    private func setupNavBar() {
        self.navigationItem.rightBarButtonItem = .init(customView: editButton)
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            avatarAndNameStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            avatarAndNameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarAndNameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            avatarImage.widthAnchor.constraint(equalToConstant: ProfileConstants.avatarSize),
            avatarImage.heightAnchor.constraint(equalToConstant: ProfileConstants.avatarSize),

            descriptionlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionlabel.topAnchor.constraint(equalTo: avatarAndNameStackView.bottomAnchor, constant: 20),

            websiteLabel.topAnchor.constraint(equalTo: descriptionlabel.bottomAnchor, constant: 8),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: ProfileConstants.cellHeight * 3)

        ])

        avatarImage.layer.cornerRadius = ProfileConstants.avatarSize / 2
        avatarImage.layer.masksToBounds = true
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 3 }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileViewCell.reuseIdentifier,
            for: indexPath
        ) as? ProfileViewCell
        else { return ProfileViewCell() }

        switch indexPath.row {
        case 0:
            cell.configCell(title: ProfileConstants.cellTitles[indexPath.row], nfts: myNFTs)
        case 1:
            cell.configCell(title: ProfileConstants.cellTitles[indexPath.row], nfts: favoriteNFTs)
        default:
            cell.configCell(with: ProfileConstants.aboutDeveloper)
        }
        return cell
    }

}
// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ProfileConstants.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showMyNFTs()
        case 1:
            showFavorites()
        default:
            break
        }
    }
}
