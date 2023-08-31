import UIKit

// MARK: - RemoveNftViewController class

final class RemoveNftViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        view.frame = self.view.bounds
        return view
    }()
    
    private lazy var nftContainerView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.alignment = .center
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var detailStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.layer.cornerRadius = Constants.Cart.radius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Cart.removeFromCart
        label.textAlignment = .center
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.regular13
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var removeNftButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(
            with: .other,
            for: Constants.Cart.remove,
            titleColor: UIColor.NFTColor.red
        )
        button.addTarget(
            self,
            action: #selector(removeNftFromCart),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var cancelActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(with: .other, for: Constants.Cart.back)
        button.addTarget(
            self,
            action: #selector(dismissViewController),
            for: .touchUpInside
        )
        return button
    }()
    
    private let viewModel: CartViewModelProtocol
    private var nftId: String?
    
    // MARK: - Initializers
    
    init(viewModel: CartViewModelProtocol, nftId: String) {
        self.viewModel = viewModel
        self.nftId = nftId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addSubviews()
    }
}

// MARK: - Add Subviews

private extension RemoveNftViewController {
    
    func addSubviews() {
        view.addSubview(blurEffectView)
        addNftContainerView()
        addDetailStackView()
        addButtonStackView()
    }
    
    func addNftContainerView() {
        view.addSubview(nftContainerView)
        
        NSLayoutConstraint.activate([
            nftContainerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            nftContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 56),
            nftContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -56)
        ])
    }
    
    func addDetailStackView() {
        nftContainerView.addArrangedSubview(detailStackView)
        detailStackView.addArrangedSubview(nftImageView)
        detailStackView.addArrangedSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            detailStackView.leadingAnchor.constraint(equalTo: nftContainerView.leadingAnchor, constant: 41),
            detailStackView.trailingAnchor.constraint(equalTo: nftContainerView.trailingAnchor, constant: -41)
        ])
    }
    
    func addButtonStackView() {
        nftContainerView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(removeNftButton)
        buttonStackView.addArrangedSubview(cancelActionButton)
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: nftContainerView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: nftContainerView.trailingAnchor)
        ])
    }
}

// MARK: - Private methods

private extension RemoveNftViewController {
    
    @objc func removeNftFromCart() {
        guard let id = nftId else { return }
        viewModel.removeNft(by: id)
        dismiss(animated: true)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}
