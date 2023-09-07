//
//  UIViewController+Extensions.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 07.09.2023.
//

import UIKit

extension UIViewController {
    func makeNavBarWithBackButtonAndTitle(
        title: String,
        navigationBar: inout UINavigationBar?
    ) {
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
        self.title = title
        navigationBar = navBar
    }
    
    @objc private func didBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
