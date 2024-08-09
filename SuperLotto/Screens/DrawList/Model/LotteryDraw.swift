//
//  LotteryDraw.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Foundation

struct LotteryDraw: Decodable, Identifiable, Equatable {
    let id: String
    let drawDate: String
    let number1: String
    let number2: String
    let number3: String
    let number4: String
    let number5: String
    let number6: String
    let bonusBall: String
    let topPrize: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case drawDate
        case number1
        case number2
        case number3
        case number4
        case number5
        case number6
        case bonusBall = "bonus-ball"
        case topPrize
    }
}

struct LotteryDraws: Decodable {
    let draws: [LotteryDraw]
}
