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
        HStack {
            Image(systemName: "calendar")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 12)

            VStack(alignment: .leading) {
                Text("\(viewModel.drawDate)")
                    .font(.headline)
                    .fontWeight(.bold)

                Text("Prize Amount: \(viewModel.topPrize.capitalized)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    LotteryDrawItemView(viewModel: LotteryDrawItemViewModel(drawDate: "vv", topPrize: "bb"))
}
