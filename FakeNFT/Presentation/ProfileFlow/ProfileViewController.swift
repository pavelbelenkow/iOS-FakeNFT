import UIKit

final class ProfileViewController: UIViewController {

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ProfileEdit"), for: .normal)
        button.tintColor = UIColor.NFTColor.black
        return button
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        setupView()
        activateConstraints()
    }

    //MARK: - Private functions
    private func setupView() {
        view.addSubview(editButton)
    }

    private func activateConstraints() {
        let editButtonSize: CGFloat = 42
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            editButton.widthAnchor.constraint(equalToConstant: editButtonSize),
            editButton.heightAnchor.constraint(equalToConstant: editButtonSize)
        ])

    }
}
