//
//  FetchLotteryDrawListUseCase.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Combine
import Foundation

protocol FetchLotteryDrawListUseCaseProtocol {
    func execute() -> AnyPublisher<DomainResult<[LotteryDraw]>, Never>
}

final class FetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol {

    private let lotteryDrawService: LotteryDrawResultFetchable

    init(
        lotteryDrawService: LotteryDrawResultFetchable = MockLotteryDataService()
    ) {
        self.lotteryDrawService = lotteryDrawService
    }

    func execute() -> AnyPublisher<DomainResult<[LotteryDraw]>, Never> {
        lotteryDrawService
            .fetchLotteryDraws()
            .receive(on: DispatchQueue.main)
            .map(DomainResult<[LotteryDraw]>.success)
            .catch { error in
                Just(.error(error))
            }
            .eraseToAnyPublisher()
    }
}

// MARK: For preview
final class PreviewFetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol {
    func execute() -> AnyPublisher<DomainResult<[LotteryDraw]>, Never> {
        Just([DeveloperPreview.instance.lotteryDraw])
            .map(DomainResult<[LotteryDraw]>.success)
            .eraseToAnyPublisher()
    }
}
