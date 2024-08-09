//
//  LotteryDrawDetailViewModel.swift
//  SuperLotto
//
//  Created by Abin Baby on 09/08/2024.
//

import Combine

final class LotteryDrawDetailViewModel: ObservableObject {

    let didSelectDismissView = PassthroughSubject<Void, Never>()

    @Published private(set) var lotteryDraws: [LotteryDraw] = []
    @Published var selectedTab: String

    init(
        selectedId: String,
        lotteryDraws: [LotteryDraw]
    ) {
        self.lotteryDraws = lotteryDraws
        self.selectedTab = selectedId
    }
}
