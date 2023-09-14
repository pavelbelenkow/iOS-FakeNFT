import UIKit

final class EditProfileViewController: UIViewController {

    var profileViewModel: ProfileViewModel?

    private var editingViewModel = EditProfileViewModel()

    private var isPhotoLinkTextFieldVisible = false

    private enum Constants {
        static let photoSize: CGFloat = 70
        static let exitButtonSize: CGFloat = 60

        static let changePhotoLabelText = "Сменить фото"
        static let photoLinkPlaceholder = "Вставьте ссылку на изображение"
        static let nameLabelText = "Имя"
        static let descriptionLabelText = "Описание"
        static let websiteLabelText  = "Сайт"
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
        label.text = Constants.changePhotoLabelText
        return label
    }()

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        return imageView
    }()

    private lazy var photoLinkTextField: UITextField = {
        let textField = UITextField()
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.NFTColor.black,
            .font: UIFont.bodyRegular
        ]
        textField.attributedPlaceholder = NSAttributedString(string: Constants.photoLinkPlaceholder,
                                                   attributes: placeholderAttributes)
        textField.font = UIFont.bodyRegular
        textField.backgroundColor = UIColor.NFTColor.white
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = !self.isPhotoLinkTextFieldVisible
        return textField
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
        EditScreenCustomLabel(frame: .zero, string: Constants.nameLabelText)
    }()

    private lazy var nameTextField: EditScreenCustomTextField = {
        EditScreenCustomTextField()
    }()

    private lazy var descriptionStackView: TitleAndTextFieldStackView = {
        TitleAndTextFieldStackView()
    }()

    private lazy var descriptionLabel: EditScreenCustomLabel = {
        EditScreenCustomLabel(frame: .zero, string: Constants.descriptionLabelText)
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .bodyRegular
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.NFTColor.lightGray
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        textView.layer.cornerRadius = 12
        textView.layer.masksToBounds = true
        return textView
    }()

    private lazy var websiteStackView: TitleAndTextFieldStackView = {
        TitleAndTextFieldStackView()
    }()

    private lazy var websiteLabel: EditScreenCustomLabel = {
        EditScreenCustomLabel(frame: .zero, string: Constants.websiteLabelText)
    }()

    private lazy var websiteTextField: EditScreenCustomTextField = {
        EditScreenCustomTextField()
    }()

    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ProfileCross"), for: .normal)
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
        descriptionTextView.delegate = self
        websiteTextField.delegate = self
        photoLinkTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        websiteTextField.addTarget(self, action: #selector(websiteTextFieldDidChange), for: .editingChanged)
        photoLinkTextField.addTarget(self, action: #selector(photoTextFieldDidChange), for: .editingChanged)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileViewModel?.getUserInfo()
    }

    // MARK: - Private functions
    private func setDataToTextFields() {
        guard let user = profileViewModel?.user else { return }
        self.nameTextField.text = user.name
        self.descriptionTextView.text = user.description
        self.websiteTextField.text = user.website
        self.photoImageView.loadImage(url: user.avatar.toURL, cornerRadius: Constants.photoSize/2)

        editingViewModel.newPhotoLink = user.avatar
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

    @objc private func photoImageViewTapped() {
        photoLinkTextField.isHidden.toggle()
        isPhotoLinkTextFieldVisible = !photoLinkTextField.isHidden
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

    @objc private func photoTextFieldDidChange(_ textField: UITextField) {
        editingViewModel.photoLinkChanged?(textField.text)
    }

    // MARK: - UI Functions
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(exitButton)
        let stacks = [nameStackView, descriptionStackView, websiteStackView]
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(descriptionTextView)
        websiteStackView.addArrangedSubview(websiteLabel)
        websiteStackView.addArrangedSubview(websiteTextField)

        view.addSubview(containerStackView)
        view.addSubview(photoImageView)
        view.addSubview(photoLinkTextField)

        stacks.forEach {containerStackView.addArrangedSubview($0)}
        photoImageView.addSubview(overlayView)
        overlayView.addSubview(changePhotoLabel)

    }

    private func activateConstraints() {
        let edge: CGFloat = 16
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: edge),
            exitButton.heightAnchor.constraint(equalToConstant: Constants.exitButtonSize),
            exitButton.widthAnchor.constraint(equalToConstant: Constants.exitButtonSize),

            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: Constants.photoSize),
            photoImageView.widthAnchor.constraint(equalToConstant: Constants.photoSize),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),

            photoLinkTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edge),
            photoLinkTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edge),
            photoLinkTextField.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 12),

            containerStackView.topAnchor.constraint(equalTo: photoLinkTextField.bottomAnchor, constant: 6),
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
    }
}

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        editingViewModel.descriptionChanged?(textView.text)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
