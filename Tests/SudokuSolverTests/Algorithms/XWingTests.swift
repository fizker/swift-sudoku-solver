import FzkExtensions
import XCTest
@testable import SudokuSolver

final class XWingTests: XCTestCase {
	let algo = XWing()

	/// There is an XWing on R1+6 C1+4
	func test__puzzleHasXWing__pencilMarksAreUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
			-3- --- 674
			5-6 7-- -9-
			79- 36- -8-

			2-7 6-- 45-
			9-- --7 8-2
			-5- --2 --7

			--- 478 -3-
			-7- --- 148
			4-- --- 72-
			"""
		) ~ { $0.pencilMarkKnownValues() }

		let xwing = try [
			Coordinate(row: 1, column: 1),
			Coordinate(row: 1, column: 4),
			Coordinate(row: 6, column: 1),
			Coordinate(row: 6, column: 4),
		]

		let cellsAffectedByXWing = try [
			Coordinate(row: 1, column: 3),
			Coordinate(row: 1, column: 5),
			Coordinate(row: 6, column: 3),
			Coordinate(row: 6, column: 5),
		]

		for cell in (puzzle.columns[0].cells + puzzle.columns[0].cells).filter(notAt: xwing) {
			XCTAssertFalse(cell.pencilMarks.contains(8), cell.debugDescription)
		}

		for cell in puzzle.cells.filter(at: cellsAffectedByXWing) {
			XCTAssertTrue(cell.pencilMarks.contains(8), cell.debugDescription)
		}

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: cellsAffectedByXWing) {
			XCTAssertFalse(cell.pencilMarks.contains(8), cell.debugDescription)
		}
	}
}
