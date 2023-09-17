//
//  UIImageView+Extensions.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(url: URL) {
        self.kf.setImage(
            with: url,
            options: [
                .cacheSerializer(FormatIndicatedCacheSerializer.png)
            ]
        )
    }
}
