import UIKit

final class EditScreenCustomTextField: UITextField {

    private let inset: CGFloat = 16

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: inset, dy: inset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: inset, dy: inset)
    }
    private func setupView() {
        font = UIFont.bodyRegular
        backgroundColor = UIColor.NFTColor.lightGray
        textAlignment = .left
        layer.cornerRadius = 12
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
