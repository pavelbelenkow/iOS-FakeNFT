//
//  NFTCellDelegate.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 11.09.2023.
//

import Foundation

protocol NFTCellDelegate: AnyObject {
    func addNFTToFavourites(id: String)
    func cartNFT(id: String)
}
