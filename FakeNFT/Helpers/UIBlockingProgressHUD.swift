import UIKit
import ProgressHUD

/// Класс для блокирования пользовательского ввода и отображения индикатора загрузки
final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }

    /// Блокирует пользовательский ввод и отображает индикатор загрузки
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    /// Разблокирует пользовательский ввод и скрывает индикатор загрузки
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }

    /**
     Разблокирует пользовательский ввод и показывает неуспешность запроса с сообщением об ошибке
     - Parameter message: Сообщение об ошибке
     */
    static func showFailed(with message: String? = nil) {
        window?.isUserInteractionEnabled = true
        ProgressHUD.showFailed(message, interaction: false)
    }

    /**
     Разблокирует пользовательский ввод и показывает сообщение об ошибке
     - Parameters:
        - message: Сообщение об ошибке
        - icon: Иконка предупреждения ошибки
     */
    static func showError(with message: String? = nil, icon: AlertIcon) {
        window?.isUserInteractionEnabled = true
        ProgressHUD.show(message, icon: icon, interaction: false)
    }
}
