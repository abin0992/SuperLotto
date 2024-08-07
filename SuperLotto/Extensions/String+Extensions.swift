//
//  String+Extensions.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Foundation

extension String {
    var capitalizedFirst: String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
}
