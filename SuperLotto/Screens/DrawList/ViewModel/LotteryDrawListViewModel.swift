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

    @Published private(set) var state = StateModel<[LotteryDrawItemViewModel]>.State.loading
    @Published private(set) var isConnected = false
    @Published private var lotteryDraws = [LotteryDraw]()

    let didTapRetry = PassthroughSubject<Void, Never>()
    let didSelectDrawItem = PassthroughSubject<LotteryDrawItemViewModel, Never>()
    let refreshDrawResults = PassthroughSubject<Void, Never>()

    private lazy var fetchLotteryDrawListResult = makeLotteryDrawFetchResult()
        .share()

    private var cancellables = Set<AnyCancellable>()

    private let reachabilityChecker: NetworkReachabilityProtocol
    private let fetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol

    init(
        fetchLotteryDrawListUseCase: FetchLotteryDrawListUseCaseProtocol = FetchLotteryDrawListUseCase(),
        reachabilityChecker: NetworkReachabilityProtocol = ReachabilityChecker()
    ) {
        self.fetchLotteryDrawListUseCase = fetchLotteryDrawListUseCase
        self.reachabilityChecker = reachabilityChecker
        setUpBindings()
    }
}

private extension LotteryDrawListViewModel {

    func setUpBindings() {
        bindState()
        bindNetworkConnectionCheck()
        bindLotteryDraws()
        bindDidSelectDraw()
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
        reachabilityChecker.statusPublisher
            .receive(on: DispatchQueue.main)
            .map { $0 == .connected }
            .assign(to: &$isConnected)

        // TODO: when "isConnected" fetch new data if necessery. 
    }

    func bindLotteryDraws() {
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
    }

    func bindDidSelectDraw() {
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
