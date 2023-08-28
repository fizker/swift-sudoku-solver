import FzkExtensions
import XCTest
@testable import SudokuSolver

extension Bool {
	var inversed: Bool { !self }
}

final class NakedPairTests: XCTestCase {
	let algo = NakedPair()

	func test__nakedPairPresent__pencilMarksAreUpdated_pairsThatDoesNothingAreIgnored() async throws {
		// G1 have one naked pair. Cells (R1C1 and R3C1) clears out the other two cells in G1.
		// This then introduces a new pair (R3C2 and R3C3) which affect cell R3C7.
		let puzzle = try Puzzle(dsl: """
			-91 354 ---
			234 --- 591
			--- 219 -34

			5-- 89- ---
			1-- 52- --9
			329 -46 --5

			91- -35 --2
			8-- --- -5-
			4-- --- -1-
			"""
		) ~ { $0.pencilMarkKnownValues() }

		let secondPair = try [
			Coordinate(row: 3, column: 2),
			Coordinate(row: 3, column: 3),
		]
		let affectedCell = try Coordinate(row: 3, column: 7)

		func cells(_ p: Puzzle) -> [Cell] {
			p.cells.filter(at: secondPair)
		}

		for cell in cells(puzzle) {
			XCTAssertEqual(cell.pencilMarks, [5,6,7,8])
		}
		XCTAssertEqual(puzzle.cells.cell(at: affectedCell).pencilMarks, [6,7,8])

		let afterFirstSolve = algo(puzzle)

		for cell in cells(afterFirstSolve) {
			XCTAssertEqual(cell.pencilMarks, [5,8])
		}
		XCTAssertEqual(afterFirstSolve.cells.cell(at: affectedCell).pencilMarks, [6,7,8])

		let afterSecondSolve = algo(afterFirstSolve)

		XCTAssertEqual(afterSecondSolve.cells.cell(at: affectedCell).pencilMarks, [6,7])
	}
}
