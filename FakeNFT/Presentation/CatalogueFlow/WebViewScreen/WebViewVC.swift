//
//  WebViewVC.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit
import WebKit

final class WebViewVC: UIViewController, WKNavigationDelegate {
    // MARK: Private Properties
//    private var webView: WKWebView!
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    var urlString: String?

    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        // поменял на синий
        progressView.tintColor = UIColor.NFTColor.blue
        progressView.progress = 0.0
        progressView.translatesAutoresizingMaskIntoConstraints = false

        return progressView
    }()

    private var observer: NSKeyValueObservation?

    // MARK: View Controller Life Cycle
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.navigationDelegate = self
//        view = webView
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // добавил
        view.backgroundColor = UIColor.NFTColor.white
        self.makeNavBarWithBackButtonAndTitle(
            title: "",
            isBackedToScreenWithHiddenTabBar: true
        )
        makeView()
        loadPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        observer?.invalidate()
    }

    // MARK: Private Methods
    private func loadPage() {
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    private func updateProgress() {
        let duration = 0.8
        let progress: Float = Float(webView.estimatedProgress)

        UIView.animate(withDuration: duration, animations: {
            self.progressView.setProgress(progress, animated: true)
        }) {
            _ in
            self.progressView.progress = 1.0
        }

        progressView.isHidden = abs(progressView.progress - 1.0) <= 0.001
    }

    private func addObserver() {
        observer = webView.observe(\.estimatedProgress) {
            [weak self] _, _ in
            guard let self else { return }
            self.updateProgress()
        }
    }

    private func makeView() {
        addSubviews()
        applyConstraints()
    }

    private func addSubviews() {
        view.addSubview(webView)
        webView.addSubview(progressView)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            webView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            webView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            webView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])

        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            progressView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            progressView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
    }
}
