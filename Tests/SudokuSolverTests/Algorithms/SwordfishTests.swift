import FzkExtensions
import XCTest
@testable import SudokuSolver

final class SwordfishTests: XCTestCase {
	let algo = Swordfish()

	func test__patternPresent_columnsHave333Pattern__pencilMarksAreUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
		529 41- 7-3
		--6 --3 --2
		--3 2-- ---

		-52 3-- -76
		637 -5- 2--
		19- 627 53-

		3-- -69 42-
		2-- 83- 6--
		96- 742 3-5
		""", pencilMarked: true)

		let cellsToUpdate = try [
			Coordinate(row: 2, column: 2),
			Coordinate(row: 2, column: 8),
			Coordinate(row: 3, column: 2),
			Coordinate(row: 3, column: 9),
			Coordinate(row: 3, column: 6),
		]

		for cell in puzzle.cells.filter(at: cellsToUpdate) {
			XCTAssertTrue(cell.pencilMarks.contains(8))
		}

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: cellsToUpdate) {
			XCTAssertFalse(cell.pencilMarks.contains(8))
		}
	}

	func test__patternPresent_columnsHave222Pattern__pencilMarksAreUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
		926 --- 1--
		537 -1- 42-
		841 --- 6-3

		259 734 816
		714 -6- -3-
		368 12- -4-

		1-2 --- -84
		485 -71 36-
		6-3 --- --1
		""", pencilMarked: true)
			|> HiddenPair().callAsFunction(_:)

		let cellsToUpdate = try [
			Coordinate(row: 3, column: 4),
			Coordinate(row: 3, column: 6),
			Coordinate(row: 7, column: 7),
			Coordinate(row: 9, column: 4),
			Coordinate(row: 9, column: 6),
			Coordinate(row: 9, column: 7),
		]

		for cell in puzzle.cells.filter(at: cellsToUpdate) {
			XCTAssertTrue(cell.pencilMarks.contains(9))
		}

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: cellsToUpdate) {
			XCTAssertFalse(cell.pencilMarks.contains(9))
		}
	}

	func test__patternPresent_rowsHave323Pattern__pencilMarksAreUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
		-2- -43 -69
		--3 896 2--
		96- -25 -3-

		89- 56- -13
		6-- -3- ---
		-3- -81 -26

		3-- -1- -7-
		--9 674 3-2
		27- 358 -9-
		""", pencilMarked: true)

		let cellsToUpdate = try [
			Coordinate(row: 2, column: 9),
			Coordinate(row: 5, column: 3),
			Coordinate(row: 5, column: 7),
			Coordinate(row: 5, column: 9),
			Coordinate(row: 6, column: 3),
			Coordinate(row: 6, column: 7),
			Coordinate(row: 7, column: 3),
			Coordinate(row: 7, column: 7),
			Coordinate(row: 7, column: 9),
		]

		for cell in puzzle.cells.filter(at: cellsToUpdate) {
			XCTAssertTrue(cell.pencilMarks.contains(4))
		}

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: cellsToUpdate) {
			XCTAssertFalse(cell.pencilMarks.contains(4))
		}
	}
}
