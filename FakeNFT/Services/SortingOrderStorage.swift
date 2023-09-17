//
//  SortingOrderStorage.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 01.09.2023.
//

import Foundation

final class SortingOrderStorage {
    private let userDefaults = UserDefaults.standard
    private let nameKey = "statisticIsRatingOrder"
    
    var isRatingOrder: Bool {
        get {
            return userDefaults.bool(forKey: nameKey)
        }
        set {
            userDefaults.set(newValue, forKey: nameKey)
        }
    }
    
    init() {
        if userDefaults.object(forKey: nameKey) == nil {
            isRatingOrder = true
        }
    }
}
