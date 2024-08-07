//
//  LotteryDrawListView.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import SwiftUI

struct LotteryDrawListView: View {
    @StateObject private var viewModel = LotteryDrawListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.lotteryDraws, id: \.id) { draw in
                LotteryDrawItemView(viewModel: LotteryDrawItemViewModel(lotteryDraw: draw))
            }
            .navigationTitle("Lottery Draws")
        }
        .onAppear {
            viewModel.fetchLotteryDraws()
        }
    }
}

#Preview {
    LotteryDrawListView()
}
