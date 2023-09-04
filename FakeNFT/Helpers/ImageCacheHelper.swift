//
//  ImageCacheHelper.swift
//  FakeNFT
//
//  Created by Pavel Belenkow on 04.09.2023.
//

import UIKit
import Kingfisher

final class NFTImageCache {
    
    static func loadAndCacheImage(for imageView: UIImageView, with url: URL?) {
        guard let url else { return }
        
        let cache = ImageCache.default
        cache.memoryStorage.config.countLimit = 100
        
        if cache.isCached(forKey: url.absoluteString) {
            cache.retrieveImage(forKey: url.absoluteString, options: nil) { result in
                switch result {
                case .success(let value):
                    imageView.image = value.image
                case .failure(let error):
                    print("Error retrieving cached image: \(error)")
                }
            }
        } else {
            imageView.kf.setImage(
                with: url,
                options: [.transition(.fade(1)), .cacheOriginalImage]
            ) { result in
                switch result {
                case .success(let value):
                    cache.store(
                        value.image,
                        forKey: url.absoluteString,
                        processorIdentifier: "",
                        cacheSerializer: DefaultCacheSerializer.default
                    )
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
