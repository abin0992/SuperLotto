//
//  LotteryDrawCoordinator.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Combine
import Foundation
import SwiftUI

final class LotteryDrawCoordinator: Coordinator {

    var rootViewController: UINavigationController = UINavigationController()
    private var cancellables = Set<AnyCancellable>()

    func start() {
        let lotteryDrawListViewModel = LotteryDrawListViewModel()
        let lotteryDrawListViewController = UIHostingController(
            rootView: LotteryDrawListView(
                viewModel: lotteryDrawListViewModel
            )
        )
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.setViewControllers(
            [lotteryDrawListViewController],
            animated: false
        )
    }
}
