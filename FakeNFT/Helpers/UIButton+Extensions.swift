import UIKit

extension UIButton {
    
    enum NFTButton {
        case payment
        case other
        
        var font: UIFont {
            switch self {
            case .payment:
                return UIFont.NFTFont.bold17
            case .other:
                return UIFont.NFTFont.regular17
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .payment:
                return 16
            case .other:
                return 12
            }
        }
    }
    
    func configure(
        with button: NFTButton,
        for title: String,
        titleColor: UIColor? = nil,
        height: CGFloat? = nil
    ) {
        backgroundColor = UIColor.NFTColor.black
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor ?? UIColor.NFTColor.white, for: .normal)
        titleLabel?.font = button.font
        
        layer.cornerRadius = button.cornerRadius
        layer.masksToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height ?? 44).isActive = true
    }
}
