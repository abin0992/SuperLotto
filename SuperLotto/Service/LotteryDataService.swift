//
//  NetworkLotteryDataService.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Combine

protocol LotteryDrawResultFetchable {
    func fetchLotteryDraws() -> AnyPublisher<[LotteryDraw], Error>
}

final class NetworkLotteryDataService: LotteryDrawResultFetchable {
    func fetchLotteryDraws() -> AnyPublisher<[LotteryDraw], Error> {
        // Network request code will go here
        Just([LotteryDraw]()) // Create a publisher that emits an empty array
                    .setFailureType(to: Error.self) // Set the failure type to Error
                    .eraseToAnyPublisher() // Erase to AnyPublisher
    }
}
