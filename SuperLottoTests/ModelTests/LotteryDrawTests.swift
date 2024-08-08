//
//  LotteryDrawTests.swift
//  SuperLottoTests
//
//  Created by Abin Baby on 08/08/2024.
//

@testable import SuperLotto
import XCTest

final class LotteryDrawTests: XCTestCase {

    func test_lotteryDraws_decoding() throws {

        let lotteryDraws: LotteryDraws = TestUtilities.load(
            fromJSON: "draws",
            type: LotteryDraws.self
        )

        // Verify that the collection was decoded correctly
        XCTAssertEqual(lotteryDraws.draws.count, 3)

        let firstDraw = lotteryDraws.draws[0]
        XCTAssertEqual(firstDraw.id, "draw-1")
        XCTAssertEqual(firstDraw.drawDate, "2023-05-15")
        XCTAssertEqual(firstDraw.number1, "2")
        XCTAssertEqual(firstDraw.number2, "16")
        XCTAssertEqual(firstDraw.number3, "23")
        XCTAssertEqual(firstDraw.number4, "44")
        XCTAssertEqual(firstDraw.number5, "47")
        XCTAssertEqual(firstDraw.number6, "52")
        XCTAssertEqual(firstDraw.bonusBall, "14")
        XCTAssertEqual(firstDraw.topPrize, 4000000000)

        let secondDraw = lotteryDraws.draws[1]
        XCTAssertEqual(secondDraw.id, "draw-2")
        XCTAssertEqual(secondDraw.drawDate, "2023-05-22")
        XCTAssertEqual(secondDraw.number1, "5")
        XCTAssertEqual(secondDraw.number2, "45")
        XCTAssertEqual(secondDraw.number3, "51")
        XCTAssertEqual(secondDraw.number4, "32")
        XCTAssertEqual(secondDraw.number5, "24")
        XCTAssertEqual(secondDraw.number6, "18")
        XCTAssertEqual(secondDraw.bonusBall, "28")
        XCTAssertEqual(secondDraw.topPrize, 6000000000)

        let thirdDraw = lotteryDraws.draws[2]
        XCTAssertEqual(thirdDraw.id, "draw-3")
        XCTAssertEqual(thirdDraw.drawDate, "2023-05-29")
        XCTAssertEqual(thirdDraw.number1, "34")
        XCTAssertEqual(thirdDraw.number2, "21")
        XCTAssertEqual(thirdDraw.number3, "4")
        XCTAssertEqual(thirdDraw.number4, "58")
        XCTAssertEqual(thirdDraw.number5, "1")
        XCTAssertEqual(thirdDraw.number6, "15")
        XCTAssertEqual(thirdDraw.bonusBall, "51")
        XCTAssertEqual(thirdDraw.topPrize, 6000000000)
    }
}
