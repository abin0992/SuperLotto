//
//  LotteryDrawItemView.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import SwiftUI

struct LotteryDrawItemView: View {
    let viewModel: LotteryDrawItemViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Margin.small) {
            Label("\(viewModel.drawDate)", systemImage: "calendar")
                .font(.headline)
                .foregroundColor(.black)
            Text("Prize Amount: \(viewModel.topPrize)")
                .font(.subheadline)
        }
        .padding()
    }
}

#Preview {
    LotteryDrawItemView(viewModel: LotteryDrawItemViewModel(drawDate: "vv", topPrize: "bb"))
}
