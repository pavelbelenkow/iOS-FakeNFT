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
        return view
    }()
    
    private lazy var resultTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold22
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let isSuccess: Bool
    
    // MARK: - Initializers
    
    init(_ isSuccess: Bool) {
        self.isSuccess = isSuccess
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
    }
}

// MARK: - Add Subviews

private extension PaymentResultViewController {
    
    func addSubviews() {
        addResultStackView()
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
}
