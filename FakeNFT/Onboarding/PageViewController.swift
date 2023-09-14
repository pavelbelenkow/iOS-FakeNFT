//
//  PageViewController.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 13.09.2023.
//

import UIKit

final class PageViewController: UIViewController {
    private let backgroundImage: UIImage
    private let titlePage: String
    private let descriptionPage: String
    private let isThirdPage: Bool
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFit
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor.NFTColor.background.withAlphaComponent(0.7976).cgColor,
            UIColor.NFTColor.background.withAlphaComponent(0.0).cgColor
        ]
        gradientLayer.locations = [
            0.0,
            1.0
        ]
        backgroundImageView.layer.addSublayer(gradientLayer)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(
            UIImage.NFTIcon.xmarkUniversal,
            for: .normal
        )
        closeButton.backgroundColor = .clear
        closeButton.addTarget(
            self,
            action: #selector(didTabBarStart),
            for: .touchUpInside
        )
        closeButton.isHidden = isThirdPage
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = titlePage
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.NFTColor.whiteUniversal
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.NFTFont.bold32
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = descriptionPage
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.NFTColor.whiteUniversal
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.NFTFont.regular15
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle(
            "Что внутри?",
            for: .normal
        )
        startButton.layer.cornerRadius = 16
        startButton.clipsToBounds = true
        startButton.backgroundColor = UIColor.NFTColor.blackUniversal
        startButton.titleLabel?.font = UIFont.NFTFont.bold17
        startButton.titleLabel?.textAlignment = .center
        startButton.setTitleColor(
            UIColor.NFTColor.whiteUniversal,
            for: .normal
        )
        startButton.addTarget(
            self,
            action: #selector(didTabBarStart),
            for: .touchUpInside
        )
        startButton.isHidden = !isThirdPage
        startButton.translatesAutoresizingMaskIntoConstraints = false
        return startButton
    }()
    
    init(
        backgroundImage: UIImage,
        titlePage: String,
        descriptionPage: String,
        isThirdPage: Bool
    ) {
        self.backgroundImage = backgroundImage
        self.titlePage = titlePage
        self.descriptionPage = descriptionPage
        self.isThirdPage = isThirdPage
        
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(startButton)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 28
            ),
            closeButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            )
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 230
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            )
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 12
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            )
        ])
        
        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -66
            ),
            startButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            startButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            )
        ])
    }
    
    @objc private func didTabBarStart() {
        let tabBarController = TabBarController()
        UIApplication.shared.windows.first?.rootViewController = tabBarController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

