//
//  OnboardingViewController.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 13.09.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    private lazy var pages: [UIViewController] = {
        let one = PageViewController(
            backgroundImage: UIImage.NFTImage.onboardingOne,
            titlePage: OnboardingTitlePage.onboardingTitleOne.rawValue,
            descriptionPage: OnboardingDescriptionPage.onboardingDescriptionOne.rawValue,
            isThirdPage: false
        )

        let two = PageViewController(
            backgroundImage: UIImage.NFTImage.onboardingTwo,
            titlePage: OnboardingTitlePage.onboardingTitleTwo.rawValue,
            descriptionPage: OnboardingDescriptionPage.onboardingDescriptionTwo.rawValue,
            isThirdPage: false
        )

        let three = PageViewController(
            backgroundImage: UIImage.NFTImage.onboardingThree,
            titlePage: OnboardingTitlePage.onboardingTitleThree.rawValue,
            descriptionPage: OnboardingDescriptionPage.onboardingDescriptionThree.rawValue,
            isThirdPage: true
        )

        return [one, two, three]
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        if #available(iOS 14, *) {
            var preferredIndicatorImage: UIImage?
            pageControl.preferredIndicatorImage = UIImage.NFTIcon.paginator
            pageControl.transform = CGAffineTransform(scaleX: 2.5, y: 1.0)
        }
        pageControl.currentPageIndicatorTintColor = UIColor.NFTColor.whiteUniversal
        pageControl.pageIndicatorTintColor = UIColor.NFTColor.whiteUniversal.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }

    required init?(coder: NSCoder) {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Пока здесь, потом поставим на экран Каталог
        RateManager.showRatesController()

        dataSource = self
        delegate = self

        if let first = pages.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true
            )
        }

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }

        return pages[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }

        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
