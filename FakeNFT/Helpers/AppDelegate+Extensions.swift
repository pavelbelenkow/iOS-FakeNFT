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
            navigationBarAppearance.backgroundColor = .clear
            navigationBarAppearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

            let tabBarApperance = UITabBarAppearance()
            tabBarApperance.configureWithOpaqueBackground()
            tabBarApperance.backgroundColor = UIColor.NFTColor.white
            tabBarApperance.shadowImage = UIImage.colorForTabBar(
                color: UIColor(
                    red: 0.0,
                    green: 0.0,
                    blue: 0.0,
                    alpha: 0.0
                )
            )
            tabBarApperance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.NFTColor.blue]
            tabBarApperance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.NFTColor.black]
            tabBarApperance.stackedLayoutAppearance.normal.iconColor = UIColor.NFTColor.black
            tabBarApperance.stackedLayoutAppearance.selected.iconColor = UIColor.NFTColor.blue
            UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
            UITabBar.appearance().standardAppearance = tabBarApperance
        } else {
            UINavigationBar.appearance().setBackgroundImage(
                UIImage(),
                for: UIBarPosition.any,
                barMetrics: UIBarMetrics.default
            )
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().tintColor = .clear
            UINavigationBar.appearance().barTintColor = UIColor.NFTColor.white
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().clipsToBounds = false
            UINavigationBar.appearance().backgroundColor = .clear
            UITabBar.appearance().backgroundImage = UIImage.colorForTabBar(
                color: UIColor(
                    red: 0.0,
                    green: 0.0,
                    blue: 0.0,
                    alpha: 0.0
                )
            )
            UITabBar.appearance().shadowImage = UIImage.colorForTabBar(color: UIColor.NFTColor.white)
        }
    }
}
