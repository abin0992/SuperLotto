//
//  ClientError.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import Foundation

enum ClientError: Error, Equatable, LocalizedError {
    // TODO: Add other error types
    case generic
    case invalidURL
    case networkError
    case badURLResponse(url: URL)
    case unknown

    var errorDescription: String? {
        switch self {
        case .badURLResponse(url: let url):
            return "[🔥] Bad response from URL: \(url)"
        default:
            return "[⚠️] Something went wrong. Please try again."
        }
    }
}
