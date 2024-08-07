//
//  Int+InWords.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Foundation

extension Int {
    var inWords: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut

        // Create a list of suffixes for large numbers
        let suffixes = ["", " thousand", " million", " billion", " trillion", " quadrillion", " quintillion", " sextillion", " septillion", " octillion", " nonillion"]

        var value = Double(self)
        var index = 0

        // Determine the appropriate suffix by dividing the value by 1000
        while value >= 1000 && index < suffixes.count - 1 {
            value /= 1000
            index += 1
        }

        // Format the number as a word
        numberFormatter.maximumFractionDigits = 0
        guard let numberInWords = numberFormatter.string(from: NSNumber(value: value)) else {
            return String(self)
        }

        return "\(numberInWords)\(suffixes[index])"
    }
}
