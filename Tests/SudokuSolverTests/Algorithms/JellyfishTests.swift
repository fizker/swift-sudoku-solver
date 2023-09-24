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

	func test__patternsFromGoodSudoku__swordfishIsFixed() async throws {
		let prepAlgos: [Algorithm] = [
			NakedPair(),
			HiddenPair(),
			PointingPair(),
		]

		let dsls: [(dsl: String, digit: Int, rows: [Int], columns: [Int])] = [
			(
				"""
				--4 -6- 58-
				8-- 4-- ---
				-7- 8-9 1--

				7-8 -14 652
				-42 -86 71-
				16- 2-- 8--

				--9 628 471
				4-- --- --8
				-87 143 9-5
				""",
				digit: 3, rows: [2,3,6,8], columns: [3,5,7,8]
			),
			(
				"""
				21- -8- ---
				4-3 -17 --8
				-58 4-- 1--

				--1 -4- --5
				68- 1-- --3
				3-- -7- 2-1

				--- --1 -9-
				1-- 73- 8--
				--- -6- -17
				""",
				digit: 9, rows: [2,6,8,9], columns: [2,3,4,6]
			),
			(
				"""
				961 253 748
				438 --7 521
				-2- 148 9--

				-4- --2 -15
				-12 -7- 89-
				89- --1 -72

				-83 7-4 -59
				-5- --- --7
				67- -2- 1--
				""",
				digit: 6, rows: [2,4,6,7], columns: [3,4,5,7]
			),
			(
				"""
				--5 42- 3--
				-2- --7 ---
				3-- --- 26-

				5-- 7-- 8--
				--- -8- -7-
				879 -14 6-2

				986 --- 7-5
				--- 6-- 92-
				--- -79 1-6
				""",
				digit: 3, rows: [4,5,8,9], columns: [2,3,6,9]
			),
			(
				"""
				87- -5- 9--
				-2- --- --7
				-13 7-6 -24

				14- --9 -75
				-95 -7- 14-
				-6- --5 -92

				-5- 961 4--
				631 --7 259
				489 523 761
				""",
				digit: 8, rows: [3,4,6,8], columns: [3,4,5,7]
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
			let solved = algo(puzzle)
			let coords = try [Coordinate](rows: test.rows, columns: test.columns)
			let failingCells = solved.cells.filter(notAt: coords)
				.filter { cell in test.rows.contains(cell.row) || test.columns.contains(cell.column) }
				.filter { cell in cell.pencilMarks.contains(test.digit) }

			XCTAssertEqual([], failingCells, test.dsl)
		}
	}

	var separator: String { Array<Puzzle>.separator }

	func parse(_ dsl: String) throws -> Array<Puzzle> {
		try .init(dsl: dsl, pencilMarked: true)
	}
}
