//
//  UserCollectionScreenViewController.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import UIKit

final class UserCollectionScreenViewController: UIViewController {
    var nfts: [String]?
    private var navBar: UINavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        makeNavBarWithBackButtonAndTitle()
        addSubviews()
        makeConstraints()
        print(nfts)
    }
    
    private func makeNavBarWithBackButtonAndTitle() {
        let navBar = self.navigationController?.navigationBar
        let backButton = UIButton(type: .custom)
        backButton.setImage(
            UIImage.NFTIcon.chevronLeft,
            for: .normal
        )
        backButton.addTarget(
            self,
            action: #selector(didBackButton),
            for: .touchUpInside
        )
        let leftNavBarItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftNavBarItem
        self.navigationController?.navigationBar.tintColor = UIColor.NFTColor.black
        self.navigationController?.title = "Коллекция NFT"
        self.navBar = navBar
    }
    
    private func addSubviews() {
        
    }
    
    private func makeConstraints() {
        
    }
    
    @objc private func didBackButton() {
        navigationController?.popViewController(animated: true)
    }
}


