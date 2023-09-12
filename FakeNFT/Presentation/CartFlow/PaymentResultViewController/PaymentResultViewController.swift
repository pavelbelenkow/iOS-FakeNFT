import UIKit

// MARK: - PaymentResultViewController class

final class PaymentResultViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var resultStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var resultImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = isSuccessImage()
        return view
    }()
    
    private lazy var resultTitleLabel: UILabel = {
        let label = UILabel()
        label.text = isSuccessTitleLabel()
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold22
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var resultButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(
            with: .payment,
            for: isSuccessButtonTitle(),
            height: 60
        )
        button.addTarget(
            self,
            action: #selector(resultButtonTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let isSuccess: Bool
    private let viewModel: OrderPaymentViewModelProtocol
    private let resultFeedbackGenerator: UINotificationFeedbackGenerator
    private let soundPlayer: PaymentResultSoundPlayer?
    
    // MARK: - Initializers
    
    init(_ isSuccess: Bool, viewModel: OrderPaymentViewModelProtocol) {
        self.isSuccess = isSuccess
        self.viewModel = viewModel
        self.resultFeedbackGenerator = UINotificationFeedbackGenerator()
        
        let soundFileName = isSuccess ? Constants.Cart.successSound : Constants.Cart.failureSound
        self.soundPlayer = PaymentResultSoundPlayer(with: soundFileName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        addSubviews()
        isSuccessFeedback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        soundPlayer?.play()
        isSuccess ? animateSuccess() : animateFailure()
    }
}

// MARK: - Add Subviews

private extension PaymentResultViewController {
    
    func addSubviews() {
        addResultStackView()
        addResultButton()
    }
    
    func addResultStackView() {
        view.addSubview(resultStackView)
        resultStackView.addArrangedSubview(resultImageView)
        resultStackView.addArrangedSubview(resultTitleLabel)
        
        NSLayoutConstraint.activate([
            resultStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            resultStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    
    func addResultButton() {
        view.addSubview(resultButton)
        
        NSLayoutConstraint.activate([
            resultButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            resultButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            resultButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Private methods

private extension PaymentResultViewController {
    
    func animateSuccess() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            animations: {
                self.resultStackView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 1,
                    animations: {
                        self.resultStackView.transform = .identity
                    }
                )
            }
        )
    }

    func animateFailure() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-6.0, 6.0, -6.0, 6.0, -3.0, 3.0, -1.0, 1.0, 0.0]
        resultStackView.layer.add(animation, forKey: "failureAnimation")
    }
    
    func isSuccessImage() -> UIImage? {
        isSuccess ? UIImage.NFTImage.successPaymentResult : UIImage.NFTImage.failurePaymentResult
    }
    
    func isSuccessTitleLabel() -> String {
        isSuccess ? Constants.Cart.successPaymentResultText : Constants.Cart.failurePaymentResultText
    }
    
    func isSuccessButtonTitle() -> String {
        isSuccess ? Constants.Cart.backToCatalogue : Constants.Cart.tryAgain
    }
    
    func isSuccessFeedback() {
        resultFeedbackGenerator.prepare()
        resultFeedbackGenerator.notificationOccurred(isSuccess ? .success : .error)
    }
    
    @objc func resultButtonTapped() {
        viewModel.handlePaymentResult(isSuccess)
        dismiss(animated: true)
    }
}
