//
//  MockFetchLotteryDrawListUseCase.swift
//  SuperLottoTests
//
//  Created by Abin Baby on 08/08/2024.
//

import Combine
@testable import SuperLotto

final class MockFetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol {

    private let shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    func execute() -> AnyPublisher<DomainResult<[LotteryDraw]>, Never> {
        let publisher: AnyPublisher<DomainResult<[LotteryDraw]>, Never>

        if shouldFail {
            publisher = Just(ClientError.generic)
                .map(DomainResult.error)
                .eraseToAnyPublisher()
        } else {
            let lotteryDraws: LotteryDraws = TestUtilities.load(
                fromJSON: "draws",
                type: LotteryDraws.self
            )
            publisher = Just(lotteryDraws.draws)
                .map(DomainResult<[LotteryDraw]>.success)
                .eraseToAnyPublisher()
        }

        return publisher
    }
}
