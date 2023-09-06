import UIKit
// TODO: impl feature in next iteration

// MARK: - PaymentResultViewController class

final class PaymentResultViewController: UIViewController {
    
    // MARK: - Properties
    
    private var isSuccess: Bool
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        
        let label = UILabel(frame: view.bounds)
        label.text = isSuccess ? "Success" : "Failure"
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    // MARK: - Initializers
    
    init(_ isSuccess: Bool) {
        self.isSuccess = isSuccess
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
