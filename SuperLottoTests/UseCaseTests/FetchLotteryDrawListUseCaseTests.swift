//
//  FetchLotteryDrawListUseCaseTests.swift
//  SuperLottoTests
//
//  Created by Abin Baby on 08/08/2024.
//

import Combine
@testable import SuperLotto
import XCTest

final class FetchLotteryDrawListUseCaseTests: XCTestCase {

    private var mockLotteryDrawRepository: MockLotteryDrawRepository!
    private var systemUnderTest: FetchLotteryDrawListUseCase!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        mockLotteryDrawRepository = MockLotteryDrawRepository()
        systemUnderTest = FetchLotteryDrawListUseCase(lotteryDrawRepository: mockLotteryDrawRepository)
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
    }

    func test_execute_success() {
        // Given
        let lotteryDraws = TestUtilities.load(
            fromJSON: "draws",
            type: LotteryDraws.self
        )
        let expectedLotteryDraws = lotteryDraws.draws
        mockLotteryDrawRepository.stubbedGetLotteryDrawsResult = .success(expectedLotteryDraws)

        // When
        let expectation = XCTestExpectation(description: "Fetch should succeed")
        systemUnderTest.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Unexpected error")
                }
            }, receiveValue: { result in
                switch result {
                case .success(let lotteryDraws):
                    XCTAssertEqual(lotteryDraws, expectedLotteryDraws)
                case .error:
                    XCTFail("Unexpected error")
                }
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_execute_failure() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockLotteryDrawRepository.stubbedGetLotteryDrawsResult = .failure(expectedError)

        // When
        let expectation = XCTestExpectation(description: "Fetch should fail")
        systemUnderTest.execute()
            .sink(
                receiveValue: { result in
                    switch result {
                    case .success:
                        XCTFail("Unexpected error")
                    case .error:
                        expectation.fulfill()
                    }
                }
            )
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
