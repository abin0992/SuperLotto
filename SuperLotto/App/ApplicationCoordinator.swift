//
//  ApplicationCoordinator.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Combine
import SwiftUI
import UIKit

final class ApplicationCoordinator: Coordinator {

    private var childCoordinators = [Coordinator]()

    private let window: UIWindow

    init(
        window: UIWindow
    ) {
        self.window = window
    }

    func start() {

        let lotteryDrawCoordinator = LotteryDrawCoordinator()
        lotteryDrawCoordinator.start()

        childCoordinators = [lotteryDrawCoordinator]
        window.rootViewController = lotteryDrawCoordinator.rootViewController
    }
}
