import FzkExtensions
import XCTest
@testable import SudokuSolver

final class XWingTests: XCTestCase {
	let algo = XWing()

	/// There is an XWing on R1+6 C1+4
	func test__puzzleHasXWing_XWingIsTriggeredOnRows__pencilMarksAreUpdated() async throws {
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

	func test__puzzleHasXWing_XWingIsTriggeredOnColumns__pencilMarksAreUpdated() async throws {
		let nonXWing = [Algorithm].all.filter { $0.name != algo.name }

		// The X-wing is on 5 between R2+7 C2+6
		let rawPuzzle = try Puzzle(dsl: """
			39- -14 2--
			--- 2-- --3
			-7- --- 9--

			-1- 3-- ---
			--- 158 --7
			--- --7 -9-

			--4 --- -3-
			2-- --1 ---
			--7 -3- -54
			"""
		)

		let puzzle = nonXWing.solve(rawPuzzle)

		XCTAssertFalse(puzzle.isSolved)

		let solved = algo(puzzle)

		XCTAssertEqual(solved.cells.cell(at: try Coordinate(row: 2, column: 1)).pencilMarks, [8], solved.debugDescription)
	}
}
