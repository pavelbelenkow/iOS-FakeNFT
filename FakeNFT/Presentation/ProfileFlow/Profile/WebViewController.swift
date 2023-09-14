//
//  WebViewController.swift
//  FakeNFT
//
//  Created by D on 14.09.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let webView = WKWebView()

    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        let request = URLRequest(url: url)
        webView.load(request)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
