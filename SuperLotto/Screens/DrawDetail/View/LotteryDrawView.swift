//
//  LotteryDrawView.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import SwiftUI

struct LotteryDrawView: View {

    let draw: LotteryDraw

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("\(draw.drawDate)", systemImage: "calendar")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Divider()

                    Text("Top Prize: \(draw.topPrize.formatted(.currency(code: "USD")))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("\(draw.topPrizeLabel.capitalized) USD")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)

                    Divider()
                }
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    Text("Numbers:")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        NumberCardView(number: draw.number1)
                        NumberCardView(number: draw.number2)
                        NumberCardView(number: draw.number3)
                        NumberCardView(number: draw.number4)
                        NumberCardView(number: draw.number5)
                        NumberCardView(number: draw.number6)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)

                Divider()

                VStack(alignment: .center, spacing: 8) {
                    Text("Bonus Ball")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    NumberCardView(number: draw.bonusBall)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

private extension LotteryDraw {
    var topPrizeLabel: String {
        topPrize.inWords.capitalizedFirst
    }
}

#Preview {
    LotteryDrawView(draw: DeveloperPreview.instance.lotteryDraw)
}
