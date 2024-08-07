//
//  FetchLotteryDrawListUseCase.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Combine
import Foundation

protocol FetchLotteryDrawListUseCaseProtocol {
    func execute() -> AnyPublisher<DomainResult<[LotteryDrawItemViewModel]>, Never>
}

final class FetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol {

    private let lotteryDrawService: LotteryDrawResultFetchable

    init(lotteryDrawService: LotteryDrawResultFetchable = MockLotteryDataService()) {
        self.lotteryDrawService = lotteryDrawService
    }

    func execute() -> AnyPublisher<DomainResult<[LotteryDrawItemViewModel]>, Never> {
        lotteryDrawService
            .fetchLotteryDraws()
            .receive(on: DispatchQueue.main)
            .map { lotteryDraws in
                lotteryDraws.map { LotteryDrawItemViewModel(lotteryDraw: $0) }
            }
            .map(DomainResult<[LotteryDrawItemViewModel]>.success)
            .catch { error in
                Just(.error(error))
            }
            .eraseToAnyPublisher()
    }
}

// MARK: For preview
final class PreviewFetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol {
    func execute() -> AnyPublisher<DomainResult<[LotteryDrawItemViewModel]>, Never> {
        Just([LotteryDrawItemViewModel(lotteryDraw: DeveloperPreview.instance.lotteryDraw)])
            .map(DomainResult<[LotteryDrawItemViewModel]>.success)
            .eraseToAnyPublisher()
    }
}
