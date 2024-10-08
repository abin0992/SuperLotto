//
//  ReachabilityChecker.swift
//  SuperLotto
//
//  Created by Abin Baby on 08/08/2024.
//

import Combine
import Network

enum NetworkStatus: String {
    case connected
    case disconnected
}

protocol NetworkReachabilityProtocol {
    var isConnected: Bool { get }
    var statusPublisher: AnyPublisher<NetworkStatus, Never> { get }
}

final class ReachabilityChecker: ObservableObject, NetworkReachabilityProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Network Monitor")

    @Published var status: NetworkStatus = .connected

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else {
                return
            }

            DispatchQueue.main.async {
                self.status = path.status == .satisfied ? .connected : .disconnected
            }
        }
        monitor.start(queue: queue)
    }

    var isConnected: Bool {
        status == .connected
    }

    var statusPublisher: AnyPublisher<NetworkStatus, Never> {
        $status.eraseToAnyPublisher()
    }
}
