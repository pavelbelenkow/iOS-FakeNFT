//
//  WebViewUserWebsiteViewController.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import UIKit
import WebKit

final class WebViewUserWebsiteViewController: UIViewController {
    var website: String?
    private var navBar: UINavigationBar?
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        self.makeNavBarWithBackButtonAndTitle(
            title: "",
            navigationBar: &navBar
        )
        addSubviews()
        makeConstraints()
        loadUserWebsite()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissProgressHUD()
        webView.stopLoading()
    }
    
    private func addSubviews() {
        view.addSubview(webView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadUserWebsite() {
        if
            let website = website,
            let url = URL(string: website) {
            self.showProgressHUD()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
        }
    }
}

extension WebViewUserWebsiteViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        self.dismissProgressHUD()
    }
}
