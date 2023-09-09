import UIKit
import Kingfisher

struct NFTImageCache {
    
    static func loadAndCacheImage(for imageView: UIImageView, with url: URL?) {
        guard let url else { return }
        
        let cache: ImageCache = .default
        cache.memoryStorage.config.countLimit = 100
        
        if cache.isCached(forKey: url.absoluteString) {
            cache.retrieveImage(forKey: url.absoluteString, options: nil) { result in
                if case .success(let value) = result {
                    imageView.image = value.image
                }
            }
        } else {
            imageView.kf.setImage(
                with: url,
                options: [.transition(.fade(1)), .cacheOriginalImage]
            ) { result in
                if case .success(let value) = result {
                    cache.store(
                        value.image,
                        forKey: url.absoluteString,
                        processorIdentifier: "",
                        cacheSerializer: DefaultCacheSerializer.default
                    )
                }
            }
        }
    }
}
