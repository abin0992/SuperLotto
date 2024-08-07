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
        VStack(alignment: .leading) {
            Text("Draw Date: \(draw.drawDate)")
                .font(.headline)
            HStack {
                Text("Numbers: \(draw.number1), \(draw.number2), \(draw.number3), \(draw.number4), \(draw.number5), \(draw.number6)")
            }
            Text("Bonus Ball: \(draw.bonusBall)")
            Text("Top Prize: \(draw.topPrize)")
        }
        .padding()
    }
}

#Preview {
    LotteryDrawView(draw: DeveloperPreview.lotteryDraw)
}
