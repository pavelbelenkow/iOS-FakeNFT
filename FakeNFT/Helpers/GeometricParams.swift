//
//  GeometricParams.swift
//  FakeNFT
//
//  Created by Anton Reynikov on 31.08.2023.
//

import Foundation

struct GeometricParams {
    //Количество ячеек по горизонтали
    let cellCount: Int
    //Отступ слева ячеек от контейнера
    let leftInset: CGFloat
    //Отступ справа ячеек от контейнера
    let rightInset: CGFloat
    //Отступ сверху ячеек от контейнера
    let topInset: CGFloat
    //Отступ снизу ячеек от контейнера
    let bottomInset: CGFloat
    //Отступ между ячейками
    let cellSpacing: CGFloat
    //Общий отступ между ячейками и между ячейками и контейнером по горизонтали
    let paddingWight: CGFloat
    
    init(
        //Количество ячеек по горизонтали
        cellCount: Int,
        //Отступ слева ячеек от контейнера
        leftInset: CGFloat,
        //Отступ справа ячеек от контейнера
        rightInset: CGFloat,
        //Отступ сверху ячеек от контейнера
        topInset: CGFloat,
        //Отступ снизу ячеек от контейнера
        bottomInset: CGFloat,
        //Отступ между ячейками
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
