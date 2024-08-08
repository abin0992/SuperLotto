//
//  LotteryDrawListViewModelTests.swift
//  SuperLottoTests
//
//  Created by Abin Baby on 08/08/2024.
//

import Combine
@testable import SuperLotto
import XCTest

final class LotteryDrawListViewModelTests: XCTestCase {

    var systemUnderTest: LotteryDrawListViewModel!
    var mockFetchUseCase: MockFetchLotteryDrawListUseCase!
    var mockReachabilityChecker: MockReachabilityChecker!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockFetchUseCase = MockFetchLotteryDrawListUseCase()
        mockReachabilityChecker = MockReachabilityChecker()
        systemUnderTest = LotteryDrawListViewModel(fetchLotteryDrawListUseCase: mockFetchUseCase)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        systemUnderTest = nil
        mockFetchUseCase = nil
        mockReachabilityChecker = nil
        super.tearDown()
    }

    func test_initialState_shouldBeLoading() {
        systemUnderTest = LotteryDrawListViewModel()
        XCTAssertEqual(systemUnderTest.state, .loading)
    }

    func test_bindNetworkConnectionCheck_connectedStatusUpdates() {
        let mockReachabilityChecker = MockReachabilityChecker()
        let systemUnderTest = LotteryDrawListViewModel(reachabilityChecker: mockReachabilityChecker)

        // When
        let connectedExpectation = XCTestExpectation(description: "isConnected should be true")
        let disconnectedExpectation = XCTestExpectation(description: "isConnected should be false")

        // Check connected state
        systemUnderTest.$isConnected
            .sink { isConnected in
                if isConnected {
                    connectedExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        mockReachabilityChecker.simulate(.connected)

        // Check disconnected state (after connected)
        systemUnderTest.$isConnected
            .sink { isConnected in
                if !isConnected {
                    disconnectedExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        mockReachabilityChecker.simulate(.disconnected)

        // Then
        wait(for: [connectedExpectation, disconnectedExpectation], timeout: 1.0) // Adjust timeout if needed
    }

    func test_makeLotteryDrawFetchResult_publishesOnTrigger() {
        systemUnderTest = LotteryDrawListViewModel(fetchLotteryDrawListUseCase: mockFetchUseCase)

        var completionValues: [StateModel<[LotteryDrawItemViewModel]>.State] = []
        let cancellable = systemUnderTest.$state
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { completionValues.append($0) }
            )
        cancellable.store(in: &cancellables)

        systemUnderTest.didTapRetry.send(())
        XCTAssertEqual(completionValues.count, 2)
        completionValues.removeAll()

        systemUnderTest.refreshDrawResults.send(())
        XCTAssertEqual(completionValues.count, 1)

        cancellable.cancel()
    }

    func test_bindState_successfulFetch() {
        // Given
        let lotteryDraws = TestUtilities.load(
            fromJSON: "draws",
            type: LotteryDraws.self
        )
        let expectedState: StateModel<[LotteryDrawItemViewModel]>.State = .data(lotteryDraws.draws.map { LotteryDrawItemViewModel(lotteryDraw: $0) })
        let systemUnderTest = LotteryDrawListViewModel(fetchLotteryDrawListUseCase: mockFetchUseCase)

        // When
        let expectation = XCTestExpectation(description: "State should update to data")
        let cancellable = systemUnderTest.objectWillChange.sink { _ in
            if systemUnderTest.state == expectedState {
                expectation.fulfill()
            }
        }
        cancellable.store(in: &cancellables)

        systemUnderTest.refreshDrawResults.send(())

        // Then
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()

        XCTAssertEqual(systemUnderTest.state, expectedState)
    }

    func test_bindState_toError() {
        // Given
        mockFetchUseCase = MockFetchLotteryDrawListUseCase(shouldFail: true)
        let systemUnderTest = LotteryDrawListViewModel(fetchLotteryDrawListUseCase: mockFetchUseCase)
        let expectedState: StateModel<[LotteryDrawItemViewModel]>.State = .error(ClientError.generic)

        // When
        let expectation = XCTestExpectation(description: "State should update to error")
        let cancellable = systemUnderTest.objectWillChange.sink { _ in
            if systemUnderTest.state == expectedState {
                expectation.fulfill()
            }
        }
        cancellable.store(in: &cancellables)

        systemUnderTest.refreshDrawResults.send(())

        // Then
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
        XCTAssertEqual(systemUnderTest.state, expectedState)
    }

    func test_didTapRetrySetsState_toLoading() {
        // When
        systemUnderTest.didTapRetry.send(())

        // Then
        XCTAssertEqual(systemUnderTest.state, .loading)
    }

    func test_didSelectDrawItemSendsOutput() {
        // Given
        let lotteryDraw = LotteryDraw(
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

        let lotteryDrawItemVM = LotteryDrawItemViewModel(lotteryDraw: lotteryDraw)

        var receivedOutput: LotteryDrawListOutput?
        systemUnderTest.output
            .sink { output in
                receivedOutput = output
            }
            .store(in: &cancellables)

        // When
        systemUnderTest.refreshDrawResults.send(())
        systemUnderTest.didSelectDrawItem.send(lotteryDrawItemVM)

        // Then
        XCTAssertNotNil(receivedOutput)
        if case let .itemSelected(itemId, allDraws) = receivedOutput! {
            XCTAssertEqual(itemId, lotteryDraw.id)
            XCTAssertEqual(allDraws.count, 3)
            XCTAssertEqual(allDraws.first?.id, lotteryDraw.id)
        }
    }
}
