import XCTest
@testable import SudokuSolver

final class TwoStringKiteTests: XCTestCase {
	let algo = TwoStringKite()

	func test__patternMatches__pencilMarksAreUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
		725 -81 -64
		169 47- -8-
		--8 --2 71-

		6-1 -49 -28
		8-- 21- 69-
		952 836 471

		-1- --8 -5-
		-86 --4 13-
		-9- 1--846
		""", pencilMarked: true)

		let solved = algo(puzzle)

		XCTAssertEqual(solved.cells.cell(at: try Coordinate(row: 2, column: 6)).pencilMarks, [3], puzzle.debugDescription)
	}
}
