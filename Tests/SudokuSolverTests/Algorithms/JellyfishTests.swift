import FzkExtensions
import XCTest
@testable import SudokuSolver

final class JellyfishTests: XCTestCase {
	let algo = Jellyfish()

	func test__patternPresent__pencilMarksAreUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
		31- -64 257
		42- 537 --9
		--7 1-2 34-

		--5 7-1 4-3
		73- --- --1
		1-2 3-6 975

		273 4-9 5--
		8-- 6-3 792
		-6- 27- -34
		""", pencilMarked: true)

		let cellsToUpdate = try [
			Coordinate(row: 2, column: 8),
			Coordinate(row: 5, column: 5),
			Coordinate(row: 5, column: 8),
		]

		for cell in puzzle.cells.filter(at: cellsToUpdate) {
			XCTAssertTrue(cell.pencilMarks.contains(8))
		}

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: cellsToUpdate) {
			XCTAssertFalse(cell.pencilMarks.contains(8))
		}
	}

	func test__patternPresentOnBothColumnsAndRows__pencilMarksAreUpdated() async throws {
		// There are two jellyfish on 3's, one on rows 2467 and one on columns 1267,
		// but they affect the same 5 cells.
		let puzzle = try Puzzle(dsl: """
		849 76- -2-
		216 --5 47-
		--7 2-4 -96

		48- --2 657
		9-- -76 -84
		76- 458 91-

		19- 6-7 -4-
		674 5-9 -3-
		-2- -4- 769
		""", pencilMarked: true)
		// The puzzle has a naked pair of 35 that would remove 3's from two cells, thus exposing the Jelly Fish
		|> NakedPair().callAsFunction(_:)

		let cellsToUpdate = try [
			Coordinate(row: 1, column: 9),
			Coordinate(row: 5, column: 3),
			Coordinate(row: 5, column: 4),
			Coordinate(row: 9, column: 3),
			Coordinate(row: 9, column: 4),
		]

		for cell in puzzle.cells.filter(at: cellsToUpdate) {
			XCTAssertTrue(cell.pencilMarks.contains(3))
		}

		let solved = algo(puzzle)

		for cell in solved.cells.filter(at: cellsToUpdate) {
			XCTAssertFalse(cell.pencilMarks.contains(3))
		}
	}
}
