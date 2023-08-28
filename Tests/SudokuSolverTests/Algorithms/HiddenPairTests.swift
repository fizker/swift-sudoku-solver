import FzkExtensions
import XCTest
@testable import SudokuSolver

final class HiddenPairTests: XCTestCase {
	let algo = HiddenPair()

	func test__hiddenPairPresent__pencilMarksAreUpdated() async throws {
		// R8 have a hidden pair on 4+9 for row 8 in columns 4 and 7.
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

		let pair = try [
			Coordinate(row: 8, column: 4),
			Coordinate(row: 8, column: 7),
		]

		XCTAssertEqual(puzzle.cells.cell(at: pair[0]).pencilMarks, [1,4,6,7,9])
		XCTAssertEqual(puzzle.cells.cell(at: pair[1]).pencilMarks, [3,4,6,7,9])

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: pair) {
			XCTAssertEqual(cell.pencilMarks, [4,9])
		}
	}

	func test__hiddenPairPresent_otherNakedPairAlreadyResolved__pencilMarksAreUpdated() async throws {
		let fakePair = try [
			Coordinate(row: 8, column: 4),
			Coordinate(row: 8, column: 7),
		]

		// G7 have a hidden pair on 2+3 for rows 8+9 in column 3.
		// There is also a hidden pair in R8, so we manually resolve that first
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
		) ~ {
			$0.pencilMarkKnownValues()
			for var cell in $0.cells.filter(at: fakePair) {
				cell.pencilMarks = [4,9]
				$0.update(cell)
			}
		}

		let pair = try [
			Coordinate(row: 8, column: 3),
			Coordinate(row: 9, column: 3),
		]

		XCTAssertEqual(puzzle.cells.cell(at: pair[0]).pencilMarks, [2,3,6,7])
		XCTAssertEqual(puzzle.cells.cell(at: pair[1]).pencilMarks, [2,3,5,6,7])

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: pair) {
			XCTAssertEqual(cell.pencilMarks, [2,3])
		}
	}
}
