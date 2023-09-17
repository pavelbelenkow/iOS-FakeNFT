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
        title: String,
        isBackedToScreenWithHiddenTabBar: Bool
    ) {
        let backButton = UIButton(type: .custom)
        backButton.setImage(
            UIImage.NFTIcon.chevronLeft,
            for: .normal
        )
        backButton.addTarget(
            self,
            action: setSelectorBackButton(
                isBackedToScreenWithHiddenTabBar: isBackedToScreenWithHiddenTabBar
            ),
            for: .touchUpInside
        )
        let leftNavBarItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftNavBarItem
        self.navigationController?.navigationBar.tintColor = UIColor.NFTColor.black
        self.title = title
    }

    @objc private func didBackButtonToScreenWithHiddenTabBar() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func didBackButtonToScreenWithNotHiddenTabBar() {
        self.tabBarController?.tabBar.isHidden = false
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

    func hideTabBar() {
        if let tabBarController = self.tabBarController {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [.curveEaseOut],
                animations: {
                    tabBarController.tabBar.frame = CGRect(
                        x: tabBarController.tabBar.frame.origin.x,
                        y: UIScreen.main.bounds.height,
                        width: tabBarController.tabBar.frame.width,
                        height: tabBarController.tabBar.frame.height
                    )
                }) { _ in
                    tabBarController.tabBar.isHidden = true
                }
        }
    }

    func showTabBar() {
        if let tabBarController = self.tabBarController {
            if !tabBarController.tabBar.isHidden {
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    options: [.curveEaseOut],
                    animations: {
                        tabBarController.tabBar.frame = CGRect(
                            x: tabBarController.tabBar.frame.origin.x,
                            y: UIScreen.main.bounds.height - tabBarController.tabBar.frame.height,
                            width: tabBarController.tabBar.frame.width,
                            height: tabBarController.tabBar.frame.height
                        )
                    })
            }
        }
    }

    private func setSelectorBackButton(isBackedToScreenWithHiddenTabBar: Bool) -> Selector {
        if isBackedToScreenWithHiddenTabBar {
            return #selector(didBackButtonToScreenWithHiddenTabBar)
        } else {
            return #selector(didBackButtonToScreenWithNotHiddenTabBar)
        }
    }

    /**
     Отображает предупреждающее диалоговое окно
     - Parameters:
        - title: Заголовок диалогового окна
        - message: Сообщение, отображаемое в диалоговом окне
        - retryTitle: Заголовок кнопки повтора действия (необязательный параметр, по умолчанию заголовок **Повторить**)
        - retryAction: Действие, выполняемое при нажатии на кнопку повтора (необязательный параметр, по умолчанию **nil**)
     */
    func showAlert(
        title: String?,
        message: String?,
        retryTitle: String? = Constants.Cart.retryText,
        retryAction: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let retryAlertAction = UIAlertAction(
            title: retryTitle,
            style: .default
        ) { _ in
            retryAction?()
        }

        let cancelAlertAction = UIAlertAction(
            title: Constants.Cart.cancelText,
            style: .cancel
        )

        retryAction == nil ? () : alertController.addAction(cancelAlertAction)
        alertController.addAction(retryAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}
