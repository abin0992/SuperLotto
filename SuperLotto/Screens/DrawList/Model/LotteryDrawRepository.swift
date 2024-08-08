//
//  LotteryDrawRepository.swift
//  SuperLotto
//
//  Created by Abin Baby on 08/08/2024.
//

import Combine
import Foundation

protocol LotteryDrawRepositoryProtocol {
    func getLotteryDraws() -> AnyPublisher<[LotteryDraw], Error>
}

final class LotteryDrawRepository: LotteryDrawRepositoryProtocol {

    private let reachabilityChecker = ReachabilityChecker()
    private let networkLotteryDrawService: LotteryDrawResultFetchable
    private let localLotteryDrawService: LotteryDrawResultFetchable

    init(
        networkLotteryDrawService: LotteryDrawResultFetchable = MockLotteryDataService(),
        localLotteryDrawService: LotteryDrawResultFetchable = MockLotteryDataService()
    ) {
        self.networkLotteryDrawService = networkLotteryDrawService
        self.localLotteryDrawService = localLotteryDrawService
    }

    func getLotteryDraws() -> AnyPublisher<[LotteryDraw], Error> {
        if reachabilityChecker.isConnected {
            networkLotteryDrawService
                .fetchLotteryDraws()
                .handleEvents(receiveOutput: { draws in
                    // TODO: Cache results
                })
                .catch { [weak self] _ in
                    guard let self else {
                        return Empty<[LotteryDraw], Error>().eraseToAnyPublisher()
                    }
                    // Fallback to local service in case of network failure
                    return self.localLotteryDrawService.fetchLotteryDraws()
                }
                .eraseToAnyPublisher()
        } else {
            // TODO: get locally cached items
            localLotteryDrawService
                .fetchLotteryDraws()
        }
    }
}
