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

    private(set) var rootViewController: UINavigationController = UINavigationController()
    private var cancellables = Set<AnyCancellable>()

    func start() {
        let lotteryDrawListViewModel = LotteryDrawListViewModel()
        lotteryDrawListViewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] outputValue in
                switch outputValue {
                case let .itemSelected(itemId, allDraws):
                    self?.presentDetailScreen(
                        LotteryDrawDetailViewModel(
                            selectedId: itemId,
                            lotteryDraws: allDraws
                        )
                    )
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

private extension LotteryDrawCoordinator {

    func presentDetailScreen(_ viewModel: LotteryDrawDetailViewModel) {

        let drawDetailView = LotteryDrawDetailView(viewModel: viewModel)
        let detailViewController = UIHostingController(rootView: drawDetailView)

        viewModel.didSelectDismissView
            .sink { _ in
                detailViewController.dismiss(animated: true)
            }
            .store(in: &cancellables)

        rootViewController.present(detailViewController, animated: true)
    }
}
