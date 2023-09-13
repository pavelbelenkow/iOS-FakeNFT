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
}
