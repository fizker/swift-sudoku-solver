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

		let solved = try running(algo, on: puzzle)

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
			|> { try running(HiddenPair(), on: $0) }

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

		let solved = try running(algo, on: puzzle)

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

		let solved = try running(algo, on: puzzle)

		for cell in solved.cells.filter(at: cellsToUpdate) {
			XCTAssertFalse(cell.pencilMarks.contains(4))
		}
	}

	func test__patternsFromGoodSudoku__swordfishIsFixed() async throws {
		let prepAlgos: [Algorithm] = [
			NakedPair(),
			HiddenPair(),
		]

		let dsls: [(dsl: String, digit: Int, rows: [Int], columns: [Int])] = [
			(
				"""
				--6 5-- -4-
				-84 2-- ---
				2-- -6- --1

				--- -2- 357
				6-- --- --9
				725 -1- ---

				9-- 78- --6
				--- --- 83-
				-6- --2 ---
				""",
				digit: 3, rows: [1,2,9], columns: [1,5,9]
			),
			(
				"""
				8-6 4-7 1-3
				--- 165 7--
				--- -8- ---

				64- -3- -71
				--8 7-1 6--
				1-- -46 -9-

				--- --4 ---
				--2 6-8 ---
				5-4 -1- 9-7
				""",
				digit: 9, rows: [1,5,8], columns: [1,2,5]
			),
			(
				"""
				--7 -2- --9
				--4 --3 --2
				215 --- ---

				84- 5-- 637
				--- 3-- 5--
				-53 4-6 928

				--- 2-- -86
				5-- 9-- 7--
				-7- -3- 295
				""",
				digit: 4, rows: [3,5,8], columns: [5,8,9]
			),
			(
				"""
				6-2 -48 9--
				8-- 9-- 642
				--- 6-2 -38

				763 -2- 89-
				-2- 879 -6-
				--8 -6- 527

				284 196 ---
				--6 --- 289
				--9 28- 416
				""",
				digit: 1, rows: [2,3,5], columns: [3,5,7]
			),
			/*
			(
				"""
				<#dsl#>
				""",
				digit: <#digit#>, rows: [<#rows#>], columns: [<#columns#>]
			),
			*/
		]

		for test in dsls {
			let puzzle = try Puzzle(dsl: test.dsl, pencilMarked: true) |> prepAlgos.solve(_:)
			guard let solved = algo(puzzle)
			else {
				XCTFail("Could not find change in\n\(test.dsl)")
				continue
			}
			let coords = try [Coordinate](rows: test.rows, columns: test.columns)
			for cell in solved.cells.filter(notAt: coords) where test.rows.contains(cell.row) || test.columns.contains(cell.column) {
				XCTAssertFalse(cell.pencilMarks.contains(test.digit), cell.debugDescription)
			}
		}
	}
}
