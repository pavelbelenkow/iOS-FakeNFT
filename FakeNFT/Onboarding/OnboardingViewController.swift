//
//  OnboardingViewController.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 13.09.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController,
                                      UIPageViewControllerDataSource,
                                      UIPageViewControllerDelegate {
    lazy var pages: [UIViewController] = {
        let one = PageViewController(
            backgroundImage: UIImage.NFTImage.onboardingOne,
            titlePage: "Исследуйте",
            descriptionPage: "Присоединяйтесь и откройте новый мир\nуникальных NFT для коллекционеров",
            isThreePage: false
        )
        
        let two = PageViewController(
            backgroundImage: UIImage.NFTImage.onboardingTwo,
            titlePage: "Коллекционируйте",
            descriptionPage: "Пополняйте свою коллекцию эсклюзивными\nкартинками, созданными нейросетью!",
            isThreePage: false
        )
        
        let three = PageViewController(
            backgroundImage: UIImage.NFTImage.onboardingThree,
            titlePage: "Состязайтесь",
            descriptionPage: "Смотрите статистику других и покажите всем,\nчто у вас самая ценная коллекция",
            isThreePage: true
        )
        
        return [one, two, three]
    }()
    
    lazy var pageControl: UIPageControl = {
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
        options: [UIPageViewController.OptionsKey : Any]? = nil
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

