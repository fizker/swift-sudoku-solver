import XCTest
@testable import SudokuSolver

final class YWingTests: XCTestCase {
	let algo = YWing()

	func test__puzzleContainsYWing__pencilMarksAreUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
		-2- 1-9 -6-
		-14 -8- 29-
		--- --- -81

		--2 --- 9--
		68- -75 ---
		--3 --- 8--

		24- --- 659
		--7 -9- 142
		-9- 4-2 738
		""", pencilMarked: true)

		let cellsInYWing = try [
			Coordinate(row: 1, column: 3),
			Coordinate(row: 7, column: 3),
			Coordinate(row: 9, column: 1),
		]
		_ = cellsInYWing // silencing unused var warning

		let cellsAffected = try [
			Coordinate(row: 1, column: 1),
			Coordinate(row: 2, column: 1),
			Coordinate(row: 3, column: 1),
			Coordinate(row: 9, column: 3),
		]

		for cell in puzzle.cells.filter(at: cellsAffected) {
			XCTAssertTrue(cell.pencilMarks.contains(5))
		}

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: cellsAffected) {
			XCTAssertFalse(cell.pencilMarks.contains(5))
		}
	}
}
