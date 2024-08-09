//
//  LotteryDrawDetailView.swift
//  SuperLotto
//
//  Created by Abin Baby on 09/08/2024.
//

import Foundation
import SwiftUI

// MARK: - ContentView
struct LotteryDrawDetailView: View {
    @ObservedObject var viewModel: LotteryDrawDetailViewModel

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Button(
                    action: {
                        viewModel.didSelectDismissView.send(())
                    },
                    label: {
                        Image(systemName: "xmark.circle.fill") // Close icon
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                )
                .padding([.top, .trailing], 16)
            }

            TabView(selection: $viewModel.selectedTab) {
                ForEach(viewModel.lotteryDraws) { draw in
                    LotteryDrawView(draw: draw)
                        .tag(draw.id)
                }
            }
            .tabViewStyle(PageTabViewStyle()) // Optional: Display the TabView as pages
        }
    }
}
