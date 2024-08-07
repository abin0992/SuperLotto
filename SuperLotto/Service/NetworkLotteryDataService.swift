//
//  NetworkLotteryDataService.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Foundation

protocol LotteryDataServiceProtocol {
    func fetchLotteryDraws(completion: @escaping (Result<[LotteryDraw], Error>) -> Void)
}

final class NetworkLotteryDataService: LotteryDataServiceProtocol {
    func fetchLotteryDraws(completion: @escaping (Result<[LotteryDraw], any Error>) -> Void) {
        // Network request code will go here
    }
}
