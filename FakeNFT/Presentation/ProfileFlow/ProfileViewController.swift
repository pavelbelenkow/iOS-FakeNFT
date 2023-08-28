import UIKit

final class ProfileViewController: UIViewController {

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
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        setupView()
        activateConstraints()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Private functions
    private func setupView() {
        view.addSubview(editButton)
        view.addSubview(avatarAndNameStackView)
        avatarAndNameStackView.addArrangedSubview(avatarImage)
        avatarAndNameStackView.addArrangedSubview(nameLabel)
        view.addSubview(descriptionlabel)
        view.addSubview(websiteLabel)
        view.addSubview(tableView)
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            editButton.widthAnchor.constraint(equalToConstant: ProfileConstants.editButtonSize),
            editButton.heightAnchor.constraint(equalToConstant: ProfileConstants.editButtonSize),

            avatarAndNameStackView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
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
        case 2:
            cell.configCell(with: ProfileConstants.aboutDeveloper)
        default:
            cell.configCell(title: ProfileConstants.cellTitles[indexPath.row], nfts: 12)
        }
        return cell
    }

}
// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ProfileConstants.cellHeight
    }
}
