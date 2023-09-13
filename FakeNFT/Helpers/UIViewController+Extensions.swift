import UIKit

extension UIViewController {
    
    /**
     Отображает предупреждающее диалоговое окно
     - Parameters:
        - title: Заголовок диалогового окна
        - message: Сообщение, отображаемое в диалоговом окне
        - retryTitle: Заголовок кнопки повтора действия (необязательный параметр, по умолчанию заголовок **Повторить**)
        - retryAction: Действие, выполняемое при нажатии на кнопку повтора (необязательный параметр, по умолчанию **nil**)
     */
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
