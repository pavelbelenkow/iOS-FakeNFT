//
//  String+Extensions.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 28.08.2023.
//

import Foundation

extension String {
    func toInt() -> Int {
        return Int(self) ?? .zero
    }
}

extension String {
    var toURL: URL {
        URL(string: self) ?? URL(fileURLWithPath: "")
    }
}
