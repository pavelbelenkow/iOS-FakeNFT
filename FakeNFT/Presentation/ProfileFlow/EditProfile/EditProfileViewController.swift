import UIKit

final class EditProfileViewController: UIViewController {

    var profileViewModel: ProfileViewModel?

    private var editingViewModel = EditProfileViewModel()

    private enum Constants {
        static let photoSize: CGFloat = 70
    }

    // MARK: - UI objects
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var changePhotoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.text = "Сменить фото"
        return label
    }()

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var nameStackView: TitleAndTextFieldStackView = {
        TitleAndTextFieldStackView()
    }()
    private lazy var nameLabel: EditScreenCustomLabel = {
        EditScreenCustomLabel(frame: .zero, string: "Имя")
    }()

    private lazy var nameTextField: EditScreenCustomTextField = {
        EditScreenCustomTextField()
    }()

    private lazy var descriptionStackView: TitleAndTextFieldStackView = {
        TitleAndTextFieldStackView()
    }()

    private lazy var descriptionLabel: EditScreenCustomLabel = {
        EditScreenCustomLabel(frame: .zero, string: "Описание")
    }()

    private lazy var descriptionTextField: EditScreenCustomTextField = {
        EditScreenCustomTextField()
    }()

    private lazy var websiteStackView: TitleAndTextFieldStackView = {
        TitleAndTextFieldStackView()
    }()

    private lazy var websiteLabel: EditScreenCustomLabel = {
        EditScreenCustomLabel(frame: .zero, string: "Сайт")
    }()

    private lazy var websiteTextField: EditScreenCustomTextField = {
        EditScreenCustomTextField()
    }()

    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ProfileCross"), for: .normal)
        button.frame.size = CGSize(width: 42, height: 42)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitButttonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setDataToTextFields()
        setupView()
        activateConstraints()

        nameTextField.delegate = self
        descriptionTextField.delegate = self
        websiteTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        descriptionTextField.addTarget(self, action: #selector(descriptionTextFieldDidChange), for: .editingChanged)
        websiteTextField.addTarget(self, action: #selector(websiteTextFieldDidChange), for: .editingChanged)
    }

    // MARK: - Private functions
    private func setDataToTextFields() {
        guard let user = profileViewModel?.user else { return }
        self.nameTextField.text = user.name
        self.descriptionTextField.text = user.description
        self.websiteTextField.text = user.website
        self.photoImageView.loadImage(url: user.avatar.toURL, cornerRadius: Constants.photoSize/2)
        editingViewModel.newName = user.name
        editingViewModel.newDesc = user.description
        editingViewModel.newWebsite = user.website
    }

    @objc
    private func exitButttonTapped() {
        editingViewModel.screenClosed()
        profileViewModel?.getUserInfo()
        self.dismiss(animated: true)
    }

    @objc private func nameTextFieldDidChange(_ textField: UITextField) {
        editingViewModel.nameChanged?(textField.text)
    }

    @objc private func descriptionTextFieldDidChange(_ textField: UITextField) {
        editingViewModel.descriptionChanged?(textField.text)
    }

    @objc private func websiteTextFieldDidChange(_ textField: UITextField) {
        editingViewModel.websiteChanged?(textField.text)
    }

    // MARK: - UI Functions
    private func setupView() {
        self.navigationItem.rightBarButtonItem = .init(customView: exitButton)
        let stacks = [nameStackView, descriptionStackView, websiteStackView]
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(descriptionTextField)
        websiteStackView.addArrangedSubview(websiteLabel)
        websiteStackView.addArrangedSubview(websiteTextField)
        view.addSubview(containerStackView)
        view.addSubview(photoImageView)
        stacks.forEach {containerStackView.addArrangedSubview($0)}
        photoImageView.addSubview(overlayView)
        overlayView.addSubview(changePhotoLabel)

    }

    private func activateConstraints() {
        let edge: CGFloat = 16
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: Constants.photoSize),
            photoImageView.widthAnchor.constraint(equalToConstant: Constants.photoSize),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),

            containerStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 24),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edge),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edge),
            containerStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),

            overlayView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),

            changePhotoLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 12),
            changePhotoLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -12),
            changePhotoLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)

        ])

        photoImageView.layer.cornerRadius = Constants.photoSize / 2
        photoImageView.layer.masksToBounds = true
    }

}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
