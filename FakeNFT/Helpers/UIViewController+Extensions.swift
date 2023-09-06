import UIKit

extension UIViewController {
    
    func showAlert(
        title: String?,
        message: String?,
        retryTitle: String? = Constants.Cart.retryText,
        retryAction: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let retryAlertAction = UIAlertAction(
            title: retryTitle,
            style: .default
        ) { _ in
            retryAction?()
        }
        
        let cancelAlertAction = UIAlertAction(
            title: Constants.Cart.cancelText,
            style: .cancel
        )
        
        retryAction == nil ? () : alertController.addAction(cancelAlertAction)
        alertController.addAction(retryAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}
