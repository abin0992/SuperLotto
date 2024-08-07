//
//  MockLotteryDataService.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import Foundation

final class MockLotteryDataService: LotteryDataServiceProtocol {

    func fetchLotteryDraws(completion: @escaping (Result<[LotteryDraw], any Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "draws", withExtension: "json") else {
            completion(.failure(NSError(domain: "Data Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load JSON"])))
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let lotteryDraws = try JSONDecoder().decode(LotteryDraws.self, from: data)
            completion(.success(lotteryDraws.draws))
        } catch {
            completion(.failure(error))
        }
    }
}
