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
        lotteryDrawListViewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] outputValue in
                switch outputValue {
                case .itemSelected(let itemId, let allDraws):
                    // Handle the extracted values here
                    print("Item ID: \(itemId)")
                    print("All Draws: \(allDraws)")
                }
            }
            .store(in: &cancellables)

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
