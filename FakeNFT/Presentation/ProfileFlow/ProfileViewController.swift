import UIKit

final class ProfileViewController: UIViewController {

    private struct ProfileConstants {
        static let editButtonSize: CGFloat = 42
        static let avatarSize: CGFloat = 70
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        setupView()
        activateConstraints()
    }

    // MARK: - Private functions
    private func setupView() {
        view.addSubview(editButton)
        view.addSubview(avatarAndNameStackView)
        avatarAndNameStackView.addArrangedSubview(avatarImage)
        avatarAndNameStackView.addArrangedSubview(nameLabel)
        view.addSubview(descriptionlabel)
        view.addSubview(websiteLabel)
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            editButton.widthAnchor.constraint(equalToConstant: ProfileConstants.editButtonSize),
            editButton.heightAnchor.constraint(equalToConstant: ProfileConstants.editButtonSize),

            avatarAndNameStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 108),
            avatarAndNameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarAndNameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            avatarImage.widthAnchor.constraint(equalToConstant: ProfileConstants.avatarSize),
            avatarImage.heightAnchor.constraint(equalToConstant: ProfileConstants.avatarSize),

            descriptionlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionlabel.topAnchor.constraint(equalTo: avatarAndNameStackView.bottomAnchor, constant: 20),

            websiteLabel.topAnchor.constraint(equalTo: descriptionlabel.bottomAnchor, constant: 8),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)

        ])

        avatarImage.layer.cornerRadius = ProfileConstants.avatarSize / 2
        avatarImage.layer.masksToBounds = true
    }
}
