//
//  LotteryDrawListViewModel.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Combine
import Foundation

enum LotteryDrawListOutput {
    case itemSelected(LotteryDraw)
}

final class LotteryDrawListViewModel: ObservableObject {

    let output = PassthroughSubject<LotteryDrawListOutput, Never>()

    @Published var state = StateModel<[LotteryDrawItemViewModel]>.State.loading

    let didTapRetry = PassthroughSubject<Void, Never>()
    let didSelectDrawItem = PassthroughSubject<LotteryDrawItemViewModel, Never>()
    let refreshDrawResults = PassthroughSubject<Void, Never>()

    private lazy var fetchLotteryDrawListResult = makeInitialResultsFetchResult()
        .share()

    private let fetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol

    init(fetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol = FetchLotteryDrawListUseCase()) {
        self.fetchLotteryDrawListUseCase = fetchLotteryDrawListUseCase
        setUpBindings()
    }
}

private extension LotteryDrawListViewModel {

    func setUpBindings() {
        bindState()
    }

    func bindState() {
        fetchLotteryDrawListResult
            .receive(on: DispatchQueue.main)
            .map { result -> StateModel<[LotteryDrawItemViewModel]>.State in
                switch result {
                case .error:
                    return .error(ClientError.generic)
                case .success(let lotteryDrawItems):
                    return .data(lotteryDrawItems)
                }
            }
            .assign(to: &$state)

        Publishers.Merge(
            didTapRetry,
            refreshDrawResults
        )
            .map { .loading }
            .assign(to: &$state)
    }

    func makeInitialResultsFetchResult() -> AnyPublisher<DomainResult<[LotteryDrawItemViewModel]>, Never> {
        Publishers.Merge3(
            Just<Void>(()),
            didTapRetry,
            refreshDrawResults
        )
        .flatMap { [fetchLotteryDrawListUseCase] _ -> AnyPublisher<DomainResult<[LotteryDrawItemViewModel]>, Never> in
            fetchLotteryDrawListUseCase.execute()
        }
        .eraseToAnyPublisher()
    }
}
