import UIKit

final class ProfileViewCell: UITableViewCell {
    static let reuseIdentifier = "profileCell"

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.textColor = UIColor.NFTColor.black
        return label
    }()

    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ProfileArrow")
        imageView.tintColor = .clear
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        activateConstraints()
        contentView.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configCell(title: String, nfts count: Int) {
        infoLabel.text = "\(title) (\(count))"
    }
    
    func configCell(with title: String) {
        infoLabel.text = title
    }

    private func setupView() {
        contentView.addSubview(infoLabel)
        contentView.addSubview(arrowImage)
    }

    private func activateConstraints() {
        let edge: CGFloat = 16
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: edge),
            infoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            arrowImage.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -edge),
            arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
