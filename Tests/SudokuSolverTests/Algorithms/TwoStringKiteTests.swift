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
		-9- 1-- 846
		""", pencilMarked: true)

		let solved = try running(algo, on: puzzle)

		let coord = try Coordinate(row: 2, column: 6)

		XCTAssertEqual(solved.cells.cell(at: coord).pencilMarks, [3], solved.debugDescription)
	}

	func test__patternMatches_thereAreMoreThanTwoCandidatesInConnectingBox__pencilMarksAreUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
		94- 3-7 --8
		5-- --- ---
		-6- --9 -7-

		--2 63- ---
		3-- --- --4
		--- --5 2--

		-7- 8-- -6-
		--- --- --3
		4-- 7-2 -85
		""", pencilMarked: true)

		let coord = try Coordinate(row: 2, column: 9)

		XCTAssertEqual(puzzle.cells.cell(at: coord).pencilMarks, [1,2,6,9])

		let solved = try running(algo, on: puzzle)

		XCTAssertEqual(solved.cells.cell(at: coord).pencilMarks, [1,6,9])
	}

	func test__patternMatches_rowCandidatesShareABox__pencilMarksAreUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
		7-- --- ---
		6-- --- ---
		--- --- ---

		--- --- ---
		9-- 8-6 54-
		8-- --- ---

		5-- --- ---
		--- -1- ---
		--- --- --1
		""", pencilMarked: true)

		let solved = try running(algo, on: puzzle)

		let coords = try [
			Coordinate(row: 1, column: 3),
			Coordinate(row: 2, column: 3),
			Coordinate(row: 3, column: 3),
		]

		for cell in puzzle.cells.filter(at: coords) {
			XCTAssertTrue(cell.pencilMarks.contains(1))
		}

		for cell in solved.cells.filter(at: coords) {
			XCTAssertFalse(cell.pencilMarks.contains(1))
		}
	}

	func test__columnCandidatesShareCellWithRowCandidates__pencilMarksAreNotUpdated() async throws {
		let puzzle = try Puzzle(dsl: """
		7-- --- 1--
		--- --- ---
		--4 --- ---

		--3 --- ---
		6-- 8-- 54-
		8-- --- -1-

		51- --- ---
		--- -1- ---
		--- --- --1
		""", pencilMarked: true)

		let solved = algo(puzzle)

		XCTAssertNil(solved)
	}
}
