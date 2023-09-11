//
//  NFTScreenVC.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

final class NFTScreenVC: UIViewController {
    //MARK: Internal Properties
    lazy var NFTView = NFTScreenView(
        dataSource: self,
        collectionViewDelegate: self,
        textViewDelegate: self
    )

    let gridGeometric = GridGeometric(
        cellCount: 3, leftInset: 16, rightInset: 16, cellSpacing: 10
    )

    let nftScreenViewModel: NFTScreenViewModel

    //MARK: Initialisers
    init(catalogueCell: CatalogueCellModel) {
        nftScreenViewModel = NFTScreenViewModel(author: catalogueCell.author)
        super.init(nibName: nil, bundle: nil)
        NFTView.configView(with: catalogueCell)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //MARK: View Controller Life Cycle
    override func loadView() {
        view = NFTView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        nftScreenViewModel.getNFTCollection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }

    //MARK: Private Methods
    private func hideTabBar() {
        if let tabBarController = self.tabBarController {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut]) {
                tabBarController.tabBar.frame = CGRect(
                    x: tabBarController.tabBar.frame.origin.x,
                    y: UIScreen.main.bounds.height,
                    width: tabBarController.tabBar.frame.width,
                    height: tabBarController.tabBar.frame.height
                )
            }
        }

        navigationController?.navigationBar.tintColor = UIColor.NFTColor.black
    }

    private func showTabBar() {
        if let tabBarController = self.tabBarController {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
                tabBarController.tabBar.frame = CGRect(
                    x: tabBarController.tabBar.frame.origin.x,
                    y: UIScreen.main.bounds.height - tabBarController.tabBar.frame.height,
                    width: tabBarController.tabBar.frame.width,
                    height: tabBarController.tabBar.frame.height
                )
            }
        }
    }

    private func bind() {
        nftScreenViewModel.$nftCollection.bind { [weak self] _ in
            guard let self else { return }
            self.NFTView.updateCollectionView()
        }
    }
}

//MARK: - UITextViewDelegate
extension NFTScreenVC: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        let webViewVC = WebViewVC()
        webViewVC.urlString = "https://practicum.yandex.ru"

        navigationController?.pushViewController(webViewVC, animated: true)
        return false
    }
}

//MARK: - NFTCellDelegate
extension NFTScreenVC: NFTCellDelegate {
    func addNFTToFavourites(id: String) {
        nftScreenViewModel.addNFTToFavourites(id: id)
    }

    func cartNFT(id: String) {
        nftScreenViewModel.cartNFT(id: id)
    }
}
