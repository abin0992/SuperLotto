//
//  LotteryDrawListViewModel.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Foundation
import Combine

enum LotteryDrawListOutput {
    case itemSelected(LotteryDraw)
}

final class LotteryDrawListViewModel: ObservableObject {

    let output = PassthroughSubject<LotteryDrawListOutput, Never>()

    @Published var state = StateModel<[LotteryDrawItemViewModel]>.State.loading

    let didTapRetry = PassthroughSubject<Void, Never>()
    let refreshDrawResults = PassthroughSubject<Void, Never>()

    @Published var lotteryDraws: [LotteryDraw] = []

    private let lotteryDataService: LotteryDataServiceProtocol

    init(lotteryDataService: LotteryDataServiceProtocol = MockLotteryDataService()) {
        self.lotteryDataService = lotteryDataService
    }

    func fetchLotteryDraws() {
        lotteryDataService.fetchLotteryDraws { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let lotteryDraws):
                    self.lotteryDraws = lotteryDraws
                case .failure(let error):
                    print("Error fetching lottery draws: \(error)")
                }
            }
        }
    }
}
