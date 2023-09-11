//
//  UIViewController+Extensions.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 07.09.2023.
//

import UIKit
import ProgressHUD

extension UIViewController {
    func makeNavBarWithBackButtonAndTitle(
        title: String
    ) {
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
    }
    
    @objc private func didBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func progressStatus(_ isLoadind: Bool) {
        if isLoadind {
            ProgressHUD.show()
        } else {
            ProgressHUD.dismiss()
        }
    }
    
    func dismissProgressHUD() {
        ProgressHUD.dismiss()
    }
    
    func showProgressHUD() {
        ProgressHUD.show()
    }
}
