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

            if !viewModel.isConnected {
                VStack {
                    Spacer()
                    Text("You are currently offline. Data is being loaded from local cache.")
                        .foregroundColor(.secondary)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
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
                    .listRowSeparator(.hidden)
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
