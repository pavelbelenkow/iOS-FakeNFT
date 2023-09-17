//
//  RateManager.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 14.09.2023.
//

import Foundation
import StoreKit

final class RateManager {
    private static let userDefaults = UserDefaults.standard
    private static let nameKey = "run_count"

    static func incrementCount() {
        let count = userDefaults.integer(forKey: nameKey)
        if count < 5 {
            userDefaults.set(count + 1, forKey: nameKey)
        }
    }

    static func showRatesController () {
        // Если надо обнулить для тестирования
//        userDefaults.set(0, forKey: nameKey)
        let count = userDefaults.integer(forKey: nameKey)
        // Сработает после 5го запуска приложения
        if count == 5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                SKStoreReviewController.requestReview()
            })
        }
    }
}
