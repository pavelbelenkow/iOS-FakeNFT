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
    
    private lazy var detailNftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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
    private var nft: NFT?
    
    // MARK: - Initializers
    
    init(viewModel: CartViewModelProtocol, nft: NFT) {
        self.viewModel = viewModel
        self.nft = nft
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
        setNftImage()
    }
}

// MARK: - Add Subviews

private extension RemoveNftViewController {
    
    func addSubviews() {
        view.addSubview(blurEffectView)
        addNftContainerView()
        addDetailNftView()
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
    
    func addDetailNftView() {
        nftContainerView.addArrangedSubview(detailNftView)
        detailNftView.addSubview(nftImageView)
        detailNftView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            detailNftView.leadingAnchor.constraint(equalTo: nftContainerView.leadingAnchor, constant: 41),
            detailNftView.trailingAnchor.constraint(equalTo: nftContainerView.trailingAnchor, constant: -41),
            
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.Cart.nftImageHeight),
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.Cart.nftImageHeight),
            nftImageView.topAnchor.constraint(equalTo: detailNftView.topAnchor),
            nftImageView.centerXAnchor.constraint(equalTo: detailNftView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: detailNftView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: detailNftView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: detailNftView.bottomAnchor)
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
    
    func setNftImage() {
        guard let nft else { return }
        let imageURL = URL(string: nft.image)
        NFTImageCache.loadAndCacheImage(for: nftImageView, with: imageURL)
    }
    
    func showErrorAlert(_ error: Error) {
        showAlert(
            title: Constants.Cart.errorAlertTitle,
            message: error.localizedDescription
        ) { [weak self] in
            self?.removeNftFromCart()
        }
    }
    
    @objc func removeNftFromCart() {
        guard let nft else { return }
        
        viewModel.removeNft(by: nft.id) { [weak self] error in
            guard let self else { return }
            
            if let error {
                self.showErrorAlert(error)
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}
