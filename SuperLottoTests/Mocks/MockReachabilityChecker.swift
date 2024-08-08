//
//  MockReachabilityChecker.swift
//  SuperLottoTests
//
//  Created by Abin Baby on 08/08/2024.
//

import Combine
@testable import SuperLotto

final class MockReachabilityChecker: NetworkReachabilityProtocol {
    var status: NetworkStatus

    init(status: NetworkStatus = .connected) {
        self.status = status
    }

    var isConnected: Bool {
        status == .connected
    }

    func simulate(_ networkStatus: NetworkStatus) {
        status = networkStatus
    }

    var statusPublisher: AnyPublisher<NetworkStatus, Never> {
        Just(status).eraseToAnyPublisher()
    }
}
