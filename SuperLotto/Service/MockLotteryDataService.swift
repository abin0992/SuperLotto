//
//  MockLotteryDataService.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Combine
import Foundation

final class MockLotteryDataService: LotteryDrawResultFetchable {

    func fetchLotteryDraws() -> AnyPublisher<[LotteryDraw], any Error> {
        Future<[LotteryDraw], any Error> { promise in
            guard let url = Bundle.main.url(forResource: "draws", withExtension: "json") else {
                promise(.failure(NSError(domain: "Data Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load JSON"])))
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let lotteryDraws = try JSONDecoder().decode(LotteryDraws.self, from: data)
                promise(.success(lotteryDraws.draws))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
