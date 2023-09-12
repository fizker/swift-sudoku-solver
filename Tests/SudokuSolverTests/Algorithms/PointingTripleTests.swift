import XCTest
@testable import SudokuSolver

final class PointingTripleTests: XCTestCase {
	let algo = PointingTriple()

	func test__containsPointingTriple__updatesPencilMarks() async throws {
		let puzzle = try Puzzle(dsl: """
		--5 -86 -1-
		--8 4-1 67-
		-16 --9 ---

		--- 8-5 ---
		-2- 614 ---
		5-- -92 1-6

		-5- 963 --2
		--4 --8 -61
		--2 147 53-
		""", pencilMarked: true)

		let pointingTripleCells = try [
			Coordinate(row: 4, column: 3),
			Coordinate(row: 5, column: 3),
			Coordinate(row: 6, column: 3),
		]
		let affectedCells = try [
			Coordinate(row: 4, column: 1),
			Coordinate(row: 4, column: 2),
			Coordinate(row: 5, column: 1),
			Coordinate(row: 6, column: 2),
		]

		for cell in puzzle.cells.filter(at: pointingTripleCells + affectedCells) {
			XCTAssertTrue(cell.pencilMarks.contains(3))
		}

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: pointingTripleCells) {
			XCTAssertTrue(cell.pencilMarks.contains(3))
		}

		for cell in solved.cells.filter(at: affectedCells) {
			XCTAssertFalse(cell.pencilMarks.contains(3))
		}
	}
}
