import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(url: URL, cornerRadius: CGFloat) {
        let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
        self.kf.setImage(
            with: url,
            options: [
                .cacheSerializer(FormatIndicatedCacheSerializer.png),
                .processor(processor)
            ]
        )
    }
}
