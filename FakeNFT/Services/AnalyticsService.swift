//
//  AnalyticsService.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 14.09.2023.
//

import Foundation
import YandexMobileMetrica

enum Screen: String {
    case screenProfile
    case screenCatalog
    case screenCart
    case screenStatistic
}

enum Event: String {
    case open
    case close
    case click
}

enum Item: String {
    // Профиль
    case myNFTProfile
    case likedNFTProfile
    case aboutDeveloperProfile
    case siteProfile
    case editProfile
    case editNameProfile
    case editDescriptionProfile
    case editSiteProfile
    case editImageAddressProfile
    case sortingNFTsProfile
    case setLikeNotLikeNFTProfile
    // Каталог
    case sortingNFTsCatalog
    case collectionNFTsCatalog
    case authorCollectionNFTsCatalog
    case setLikeNotLikeNFTCatalog
    case setAddDeleteCartNFTCatalog
    // Корзина
    case deleteNFTCart
    case confirmDeleteNFTCart
    case confitmReturnNFTCart
    case sortingNFTsCart
    case toPayNFTCart
    case paymentMethodCart
    case payNFTCart
    // Статистика
    case sortingNFTsStatistic
    case userSiteStatistic
    case collectionUserNFTsStatistic
    case setLikeNotLikeNFTStatistic
    case setAddDeleteCartNFTStatistic
}

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(
            apiKey: "55daf222-f66c-4207-aebf-5d3e3d7df3d2"
        ) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }

    func report(
        screen: Screen,
        event: Event,
        param: Item?
    ) {
        var params = [
            "screen": screen.rawValue
        ]
        if param != nil {
            params.updateValue(
                param?.rawValue ?? String(),
                forKey: "item"
            )
        }
        YMMYandexMetrica.reportEvent(
            event.rawValue,
            parameters: params,
            onFailure: { error in
            print(
                "REPORT ERROR: %@",
                error.localizedDescription
            )
        })
    }
}
