import FzkExtensions
import XCTest
@testable import SudokuSolver

final class NakedTripleTests: XCTestCase {
	let algo = NakedTriple()

	func test__puzzleWithNakedTriple_cellInNakedTripleHaveAllThreePotentials__pencilMarksAreUpdated() async throws {
		let triples = try [
			Coordinate(row: 8, column: 3),
			Coordinate(row: 8, column: 4),
			Coordinate(row: 8, column: 5),
		]

		let puzzle = try Puzzle(dsl: """
			// There is a naked triple between cells R8C3 R8C4 R8C5 on 139
			32- -56 -7-
			--- --1 -3-
			9-- --8 6--

			--- 172 --4
			--- 869 ---
			1-- 543 ---

			4-6 2-7 --8
			87- --5 ---
			25- 684 -17
			"""
		) ~ { $0.pencilMarkKnownValues() }

		for cell in puzzle.cells.filter(at: triples) {
			XCTAssertEqual(cell.pencilMarks.subtracting([1,3,9]), [], cell.debugDescription)
		}

		let solved = algo(puzzle)

		for coord in triples {
			XCTAssertEqual(puzzle.cells.cell(at: coord), solved.cells.cell(at: coord))
		}

		for cell in solved.rows[7].cells.filter(notAt: triples) {
			XCTAssertFalse(cell.pencilMarks.contains(1), cell.debugDescription)
			XCTAssertFalse(cell.pencilMarks.contains(3), cell.debugDescription)
			XCTAssertFalse(cell.pencilMarks.contains(9), cell.debugDescription)
		}
	}

	func test__puzzleWithNakedTriple_cellsInNakedTripleHaveOnlyTwoPotentials__pencilMarksAreUpdated() async throws {
		let triples = try [
			Coordinate(row: 8, column: 3),
			Coordinate(row: 8, column: 4),
			Coordinate(row: 8, column: 5),
		]

		let puzzle = try Puzzle(dsl: """
			// There is a naked triple between cells R8C3 R8C4 R8C5 on 139
			// There is also a naked triple between cells R7C7 R9C7 R7C8 on 359
			32- -56 -7-
			--- --1 -3-
			9-- --8 6--

			--- 172 --4
			--- 869 ---
			1-- 543 ---

			4-6 2-7 --8
			87- --5 ---
			25- 684 -17
			"""
		) ~ {
			$0.pencilMarkKnownValues()
			var firstCell = $0.cells.cell(at: triples[0])
			firstCell.pencilMarks = [1,3]
			$0.update(firstCell)
			var thirdCell = $0.cells.cell(at: triples[2])
			thirdCell.pencilMarks = [1,9]
			$0.update(thirdCell)
			var secondCell = $0.cells.cell(at: try .init(row: 7, column: 7))
			secondCell.pencilMarks = [3,5]
			$0.update(secondCell)
		}

		XCTAssertEqual(puzzle.cells.cell(at: triples[0]).pencilMarks, [1,3])
		XCTAssertEqual(puzzle.cells.cell(at: triples[1]).pencilMarks, [3,9])
		XCTAssertEqual(puzzle.cells.cell(at: triples[2]).pencilMarks, [1,9])

		let solved = algo(puzzle)

		for coord in triples {
			XCTAssertEqual(puzzle.cells.cell(at: coord), solved.cells.cell(at: coord))
		}

		for cell in solved.rows[7].cells.filter(notAt: triples) {
			XCTAssertFalse(cell.pencilMarks.contains(1), cell.debugDescription)
			XCTAssertFalse(cell.pencilMarks.contains(3), cell.debugDescription)
			XCTAssertFalse(cell.pencilMarks.contains(9), cell.debugDescription)
		}
	}
}
