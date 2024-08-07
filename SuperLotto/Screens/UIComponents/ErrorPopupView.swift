//
//  ErrorPopupView.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import SwiftUI

struct ErrorPopupView: View {
    let title: String
    let subtitle: String?
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }

            Button(action: retryAction) {
                Text("Retry")
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ErrorPopupView(
        title: "Internal Server Error",
        subtitle: "Please Try again"
    ) { }
}
