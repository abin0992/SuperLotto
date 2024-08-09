//
//  MockLotteryDrawResultFetchable.swift
//  SuperLottoTests
//
//  Created by Abin Baby on 09/08/2024.
//

import Combine
@testable import SuperLotto

final class MockLotteryDrawResultFetchable: LotteryDrawResultFetchable {

    var stubbedFetchLotteryDrawsResult: Result<[LotteryDraw], Error> = .success([])

    func fetchLotteryDraws() -> AnyPublisher<[LotteryDraw], Error> {
        Just(stubbedFetchLotteryDrawsResult)
            .flatMap { result -> AnyPublisher<[LotteryDraw], Error> in
                switch result {
                case .success(let lotteryDraws):
                    return Just(lotteryDraws)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                case .failure(let error):
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
