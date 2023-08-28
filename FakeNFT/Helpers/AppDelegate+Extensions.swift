//
//  Extensions.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//
import UIKit

extension AppDelegate {
    func setNavigationBarAndTabBarAppearance() {
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = UIColor.NFTColor.white
            navigationBarAppearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarApperance = UITabBarAppearance()
            tabBarApperance.configureWithOpaqueBackground()
            tabBarApperance.backgroundColor = UIColor.NFTColor.white
            tabBarApperance.shadowImage = UIImage.colorForTabBar(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0))
            UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
            UITabBar.appearance().standardAppearance = tabBarApperance
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().tintColor = UIColor.NFTColor.white
            UINavigationBar.appearance().barTintColor = UIColor.NFTColor.white
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().clipsToBounds = false
            UINavigationBar.appearance().backgroundColor = UIColor.NFTColor.white
            UITabBar.appearance().backgroundImage = UIImage.colorForTabBar(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0))
            UITabBar.appearance().shadowImage = UIImage.colorForTabBar(color: UIColor.NFTColor.white)
        }
    }
}
