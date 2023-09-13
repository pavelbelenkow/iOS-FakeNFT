import UIKit

extension UIButton {
    
    /// Тип кнопки
    enum NFTButton {
        case payment
        case other
        
        /// Шрифт кнопки в зависимости от типа
        var font: UIFont {
            switch self {
            case .payment:
                return UIFont.NFTFont.bold17
            case .other:
                return UIFont.NFTFont.regular17
            }
        }
        
        /// Радиус закругления кнопки в зависимости от типа
        var cornerRadius: CGFloat {
            switch self {
            case .payment:
                return 16
            case .other:
                return 12
            }
        }
    }
    
    /**
     Конфигурирует кнопку
     - Parameters:
        - button: Тип кнопки (`NFTButton.payment` или `NFTButton.other`)
        - title: Текст, отображаемый на кнопке
        - titleColor: Цвет текста на кнопке (необязательный параметр, по умолчанию - белый)
        - height: Высота кнопки (необязательный параметр, по умолчанию - 44)
     */
    func configure(
        with button: NFTButton,
        for title: String,
        titleColor: UIColor? = UIColor.NFTColor.white,
        height: CGFloat? = 44
    ) {
        backgroundColor = UIColor.NFTColor.black
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = button.font
        
        layer.cornerRadius = button.cornerRadius
        layer.masksToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height ?? 44).isActive = true
    }
}
