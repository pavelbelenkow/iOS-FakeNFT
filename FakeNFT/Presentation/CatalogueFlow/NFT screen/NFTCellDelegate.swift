//
//  NFTCellDelegate.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 11.09.2023.
//

import Foundation

protocol NFTCellDelegate: AnyObject {
    func addNFTToFavourites(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    func cartNFT(id: String, isOrdered: Bool?, completion: @escaping (Result<Void, Error>) -> Void)
}
