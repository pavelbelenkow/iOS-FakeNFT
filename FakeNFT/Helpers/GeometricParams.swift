//
//  GeometricParams.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import Foundation

struct GeometricParams {
    /// Количество ячеек по горизонтали
    let cellCount: Int
    /// Отступ слева ячеек от контейнера
    let leftInset: CGFloat
    /// Отступ справа ячеек от контейнера
    let rightInset: CGFloat
    /// Отступ сверху ячеек от контейнера
    let topInset: CGFloat
    /// Отступ снизу ячеек от контейнера
    let bottomInset: CGFloat
    /// Отступ между ячейками
    let cellSpacing: CGFloat
    /// Общий отступ между ячейками и между ячейками и контейнером по горизонтали
    let paddingWight: CGFloat
    
    /// Инициализатор
    /// - Parameters:
    ///   - cellCount: Количество ячеек по горизонтали
    ///   - leftInset: Отступ слева ячеек от контейнера
    ///   - rightInset: Отступ справа ячеек от контейнера
    ///   - topInset: Отступ сверху ячеек от контейнера
    ///   - bottomInset: Отступ снизу ячеек от контейнера
    ///   - cellSpacing: Отступ между ячейками
    init(
        cellCount: Int,
        leftInset: CGFloat,
        rightInset: CGFloat,
        topInset: CGFloat,
        bottomInset: CGFloat,
        cellSpacing: CGFloat
    ) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.cellSpacing = cellSpacing
        self.paddingWight = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
