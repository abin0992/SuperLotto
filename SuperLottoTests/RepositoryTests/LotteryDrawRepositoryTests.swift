//
//  LotteryDrawRepositoryTests.swift
//  SuperLottoTests
//
//  Created by Abin Baby on 09/08/2024.
//

import Combine
@testable import SuperLotto
import XCTest

class LotteryDrawRepositoryTests: XCTestCase {

    private var mockNetworkLotteryDrawService: MockLotteryDrawResultFetchable!
    private var mockLocalLotteryDrawService: MockLotteryDrawResultFetchable!
    private var mockReachabilityChecker: MockReachabilityChecker!
    private var systemUnderTest: LotteryDrawRepository!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        mockNetworkLotteryDrawService = MockLotteryDrawResultFetchable()
        mockLocalLotteryDrawService = MockLotteryDrawResultFetchable()
        mockReachabilityChecker = MockReachabilityChecker()
        systemUnderTest = LotteryDrawRepository(
            networkLotteryDrawService: mockNetworkLotteryDrawService,
            localLotteryDrawService: mockLocalLotteryDrawService,
            reachabilityChecker: mockReachabilityChecker
        )
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
    }

    func test_getLotteryDraws_networkConnected_success() {
        // Given
        mockReachabilityChecker.simulate(.connected)
        let expectedLotteryDraws = [
            LotteryDraw(
                id: "draw-1",
                drawDate: "2023-05-15",
                number1: "2",
                number2: "16",
                number3: "35",
                number4: "99",
                number5: "32",
                number6: "24",
                bonusBall: "76",
                topPrize: 4000000000
            )
        ]
        mockNetworkLotteryDrawService.stubbedFetchLotteryDrawsResult = .success(expectedLotteryDraws)

        // When
        let expectation = XCTestExpectation(description: "Fetch lottery draws from network")
        systemUnderTest.getLotteryDraws()
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { lotteryDraws in
                XCTAssertEqual(lotteryDraws, expectedLotteryDraws)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_getLotteryDraws_networkDisconnected_fetchFromLocalService() {
        // Given
        mockReachabilityChecker.simulate(.disconnected)
        let lotteryDraws = TestUtilities.load(
            fromJSON: "draws",
            type: LotteryDraws.self
        )
        let expectedLotteryDraws = lotteryDraws.draws
        mockLocalLotteryDrawService.stubbedFetchLotteryDrawsResult = .success(expectedLotteryDraws)

        // When
        let expectation = XCTestExpectation(description: "Fetch lottery draws from local service")
        systemUnderTest.getLotteryDraws()
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { lotteryDraws in
                XCTAssertEqual(lotteryDraws, expectedLotteryDraws)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
