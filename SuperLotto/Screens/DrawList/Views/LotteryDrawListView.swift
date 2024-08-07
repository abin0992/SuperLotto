//
//  LotteryDrawListView.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import SwiftUI

struct LotteryDrawListView: View {

    @ObservedObject var viewModel: LotteryDrawListViewModel

    init(viewModel: LotteryDrawListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                // TODO: Use better loading view with animation
                Text("Loading...")
            case .data(let lotteryDraws):
                dataContentView(lotteryDraws: lotteryDraws)
            case .error(let clientError):
                ErrorPopupView(
                    title: "Error Occurred",
                    subtitle: clientError.localizedDescription,
                    retryAction: {
                        viewModel.didTapRetry.send(())
                    }
                )
            default:
                VStack {}
            }
        }
        .navigationBarTitle("Lottery draws")
        .navigationBarBackButtonHidden(true)
    }
}

private extension LotteryDrawListView {
    func dataContentView(lotteryDraws: [LotteryDrawItemViewModel]) -> some View {
        List {
            ForEach(lotteryDraws) { lotteryDraw in
                LotteryDrawItemView(viewModel: lotteryDraw)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 0,
                            bottom: 10,
                            trailing: 10)
                    )
                    .onTapGesture {
                        if Features.isDrawDetailScreenEnabled {
                            viewModel.didSelectDrawItem.send(lotteryDraw)
                        }
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .scrollContentBackground(.hidden)
        .refreshable {
            viewModel.refreshDrawResults.send(())
        }
    }
}

#Preview {
    LotteryDrawListView(viewModel: LotteryDrawListViewModel())
}
