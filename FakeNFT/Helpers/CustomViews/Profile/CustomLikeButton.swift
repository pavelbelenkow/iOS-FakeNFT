//
//  CustomLikeButton.swift
//  FakeNFT
//
//  Created by D on 14.09.2023.
//
import UIKit

class CustomLikeButton: UIButton {
    private let activeAreaSize: CGFloat = 18

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let hitFrame = bounds.insetBy(
            dx: (bounds.size.width - activeAreaSize) / 2,
            dy: (bounds.size.height - activeAreaSize) / 2
        )
        return hitFrame.contains(point)
    }
}
