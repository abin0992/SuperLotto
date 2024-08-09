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

    private let lotteryDrawRepository: LotteryDrawRepositoryProtocol

    init(
        lotteryDrawRepository: LotteryDrawRepositoryProtocol = LotteryDrawRepository()
    ) {
        self.lotteryDrawRepository = lotteryDrawRepository
    }

    func execute() -> AnyPublisher<DomainResult<[LotteryDraw]>, Never> {
        lotteryDrawRepository
            .getLotteryDraws()
            .receive(on: DispatchQueue.main)
            .map { lotteryDraws -> DomainResult<[LotteryDraw]> in
                let sortedDraws = lotteryDraws.sorted { $0.drawDate > $1.drawDate }
                return .success(sortedDraws)
            }
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
