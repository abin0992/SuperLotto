//
//  LotteryDrawListViewModel.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Combine
import Foundation

enum LotteryDrawListOutput {
    case itemSelected(itemId: String, allDraws: [LotteryDraw])
}

final class LotteryDrawListViewModel: ObservableObject {

    let output = PassthroughSubject<LotteryDrawListOutput, Never>()

    @Published var state = StateModel<[LotteryDrawItemViewModel]>.State.loading
    @Published var isConnected = false
    @Published private var lotteryDraws = [LotteryDraw]()

    let didTapRetry = PassthroughSubject<Void, Never>()
    let didSelectDrawItem = PassthroughSubject<LotteryDrawItemViewModel, Never>()
    let refreshDrawResults = PassthroughSubject<Void, Never>()

    private lazy var fetchLotteryDrawListResult = makeLotteryDrawFetchResult()
        .share()

    private var cancellables = Set<AnyCancellable>()
    private let rechabilityChecker = ReachabilityChecker()

    private let fetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol

    init(
        fetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol = FetchLotteryDrawListUseCase()
    ) {
        self.fetchLotteryDrawListUseCase = fetchLotteryDrawListUseCase
        setUpBindings()
    }
}

private extension LotteryDrawListViewModel {

    func setUpBindings() {
        bindState()
        bindNetworkConnectionCheck()

        fetchLotteryDrawListResult
            .compactMap { result in
                switch result {
                case .error:
                    return nil
                case .success(let lotteryDrawItems):
                    return lotteryDrawItems
                }
            }
            .assign(to: &$lotteryDraws)

        didSelectDrawItem
            .sink { [weak self] selectedDrawItem in
                guard let self else {
                    return
                }
                self.output.send(
                    LotteryDrawListOutput.itemSelected(
                        itemId: selectedDrawItem.id,
                        allDraws: self.lotteryDraws
                    )
                )
            }
            .store(in: &cancellables)

    }

    func bindState() {
        fetchLotteryDrawListResult
            .receive(on: DispatchQueue.main)
            .map { result -> StateModel<[LotteryDrawItemViewModel]>.State in
                switch result {
                case .error:
                    return .error(ClientError.generic)
                case .success(let lotteryDrawItems):
                    return .data(
                        lotteryDrawItems.map { LotteryDrawItemViewModel(lotteryDraw: $0) }
                    )
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

    func bindNetworkConnectionCheck() {
        rechabilityChecker.$status
            .map { $0 == .connected }
            .assign(to: &$isConnected)

        // TODO: when "isConnected" fetch new data if necessery. 
    }

    func makeLotteryDrawFetchResult() -> AnyPublisher<DomainResult<[LotteryDraw]>, Never> {
        Publishers.Merge3(
            Just<Void>(()),
            didTapRetry,
            refreshDrawResults
        )
        .flatMap { [fetchLotteryDrawListUseCase] _ -> AnyPublisher<DomainResult<[LotteryDraw]>, Never> in
            fetchLotteryDrawListUseCase.execute()
        }
        .eraseToAnyPublisher()
    }
}
