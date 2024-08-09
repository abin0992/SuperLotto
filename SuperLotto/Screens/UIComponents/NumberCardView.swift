//
//  NumberCardView.swift
//  SuperLotto
//
//  Created by Abin Baby on 09/08/2024.
//

import SwiftUI

struct NumberCardView: View {
    let number: String

    var body: some View {
        Text(number)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding()
            .frame(width: 80, height: 80)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .shadow(radius: 2)
    }
}

#Preview {
    NumberCardView(number: "99")
}
