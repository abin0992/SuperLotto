//
//  MockLotteryDrawRepository.swift
//  SuperLottoTests
//
//  Created by Abin Baby on 08/08/2024.
//

import Combine
@testable import SuperLotto

final class MockLotteryDrawRepository: LotteryDrawRepositoryProtocol {

    var stubbedGetLotteryDrawsResult: Result<[LotteryDraw], Error> = .success([])

    func getLotteryDraws() -> AnyPublisher<[LotteryDraw], Error> {
        Just(stubbedGetLotteryDrawsResult)
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
