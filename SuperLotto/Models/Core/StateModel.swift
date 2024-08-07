//
//  StateModel.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import Foundation

struct StateModel<T: Equatable> {

    enum State: Equatable {

        case initial
        case loading
        case updating
        case error(ClientError)
        case updatingError(ClientError)
        case data(T)

        func map<W: Equatable>(_ transform: (T) -> W) -> StateModel<W>.State {
            switch self {
            case .initial:
                return .initial
            case .loading:
                return .loading
            case .updating:
                return .updating
            case .error(let error):
                return .error(error)
            case .updatingError(let error):
                return .updatingError(error)
            case .data(let data):
                return .data(transform(data))
            }
        }
    }

    var data: T?

    var state: State = .initial {
        didSet {
            if case .data(let data) = state {
                self.data = data
            }
        }
    }

    // Initializer to allow creating an instance with a specific state
    init(state: State = .initial) {
        self.state = state
        if case .data(let data) = state {
            self.data = data
        }
    }
}
