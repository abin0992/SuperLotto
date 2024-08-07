//
//  LotteryDrawItemViewModel.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Foundation

struct LotteryDrawItemViewModel: Equatable {
    let drawDate: String
    let topPrize: String

    init(drawDate: String, topPrize: String) {
        self.drawDate = drawDate
        self.topPrize = topPrize
    }

    init(lotteryDraw: LotteryDraw) {
        self.drawDate = lotteryDraw.drawDate
        self.topPrize = lotteryDraw.topPrize.inWords.capitalizedFirst
    }
}
