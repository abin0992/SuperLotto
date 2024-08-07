//
//  LotteryDrawItemViewModel.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Foundation

struct LotteryDrawItemViewModel: Equatable, Identifiable {
    let id: String
    let drawDate: String
    let topPrize: String

    init(drawDate: String, topPrize: String) {
        self.id = UUID().uuidString
        self.drawDate = drawDate
        self.topPrize = topPrize
    }

    init(lotteryDraw: LotteryDraw) {
        self.id = lotteryDraw.id
        self.drawDate = lotteryDraw.drawDate
        self.topPrize = lotteryDraw.topPrize.inWords.capitalizedFirst
    }
}
